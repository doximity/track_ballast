# frozen_string_literal: true

require "track_ballast/uuid_management"

RSpec.describe TrackBallast::UuidManagement do
  class CreateUuidModelsTable < ActiveRecord::Migration[7.1]
    def change
      create_table :uuid_models do |table|
        table.string :uuid
      end
    end
  end

  class UuidModel < ActiveRecord::Base
    include TrackBallast::UuidManagement
  end

  before do
    ActiveRecord::Migration.suppress_messages do
      CreateUuidModelsTable.migrate(:up)
    end
  end

  it "generates a UUID after initialization" do
    expect(UuidModel.new.uuid).to be
  end

  it "generates a UUID before validation" do
    model = UuidModel.new
    model.uuid = nil
    expect(model.uuid).not_to be

    model.valid?

    expect(model.uuid).to be
  end

  it "does not validate uuid presence when the column is nullable" do
    model = UuidModel.new
    model.uuid = nil

    expect(model).to be_valid
  end

  it "does not generate a new UUID after initialization" do
    manually_assigned_uuid = SecureRandom.uuid

    model = UuidModel.new(uuid: manually_assigned_uuid)

    expect(model.uuid).to eq(manually_assigned_uuid)
  end

  it "does not generate a new uuid before validation" do
    manually_assigned_uuid = SecureRandom.uuid
    model = UuidModel.new

    model.uuid = manually_assigned_uuid

    expect(model.uuid).to eq(manually_assigned_uuid)
  end

  context "V4-UUIDs" do
    it "is case insensitive when lowercase" do
      model = UuidModel.create(uuid: SecureRandom.uuid.downcase)
      expect(model.errors.full_messages).to be_empty
    end

    it "is case insensitive when uppercase" do
      model = UuidModel.create(uuid: SecureRandom.uuid.upcase)
      expect(model.errors.full_messages).to be_empty
    end
  end

  context "non v4-UUIDs" do
    # https://www.uuidgenerator.net/version1
    let(:v1_uuid) { "c48626ce-a3b0-11ec-b909-0242ac120002" }

    context "on create" do
      it "raises validation error" do
        model = UuidModel.create(uuid: v1_uuid)

        expect(model.errors.full_messages).to eq(["Only V4 UUIDs are permitted"])
      end

      it "logs the error" do
        allow(TrackBallast.logger).to receive(:error)

        UuidModel.create(uuid: v1_uuid)

        expect(TrackBallast.logger).to have_received(:error).with(hash_including(class: "UuidModel", uuid: v1_uuid))
      end

      it "raises validation error if object is newed up and then UUID set to v1" do
        model = UuidModel.new
        expect(model).to be_valid

        model.uuid = v1_uuid

        expect(model).not_to be_valid
      end
    end

    context "on update" do
      it "saves the record" do
        model = UuidModel.new
        model.uuid = v1_uuid
        model.save(validate: false)

        expect(model.save).to be_truthy
      end
    end
  end
end
