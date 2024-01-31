# frozen_string_literal: true

require "track_ballast/uuid_management"

require "support/uuid_management_models"

RSpec.describe TrackBallast::UuidManagement do
  before do
    ActiveRecord::Migration.suppress_messages do
      CreateNullableUuidModelsTable.migrate(:up)
      CreateNonNullableUuidModelsTable.migrate(:up)
    end
  end

  it "generates a UUID after initialization" do
    expect(NullableUuidModel.new.uuid).to be
  end

  it "generates a UUID before validation" do
    model = NullableUuidModel.new
    model.uuid = nil
    expect(model.uuid).not_to be

    model.validate

    expect(model.uuid).to be
  end

  it "validates UUID presence when the column is not nullable" do
    model = NonNullableUuidModel.create
    model.uuid = nil

    model.validate

    expect(model.errors).to be_of_kind(:uuid, :blank)
    expect(model.errors).to be_of_kind(:uuid, :wrong_length)
  end

  it "does not validate UUID presence when the column is nullable" do
    model = NullableUuidModel.new
    model.uuid = nil

    expect(model).to be_valid
  end

  it "does not generate a new UUID after initialization" do
    manually_assigned_uuid = SecureRandom.uuid

    model = NullableUuidModel.new(uuid: manually_assigned_uuid)

    expect(model.uuid).to eq(manually_assigned_uuid)
  end

  it "does not generate a new UUID before validation" do
    manually_assigned_uuid = SecureRandom.uuid
    model = NullableUuidModel.new

    model.uuid = manually_assigned_uuid

    expect(model.uuid).to eq(manually_assigned_uuid)
  end

  context "v4 UUIDs" do
    it "is case-insensitive when lowercase" do
      model = NullableUuidModel.create(uuid: SecureRandom.uuid.downcase)

      expect(model).to be_valid
    end

    it "is case-insensitive when uppercase" do
      model = NullableUuidModel.create(uuid: SecureRandom.uuid.upcase)

      expect(model).to be_valid
    end
  end

  context "non-v4 UUIDs" do
    # https://www.uuidgenerator.net/version1
    let(:v1_uuid) { "c48626ce-a3b0-11ec-b909-0242ac120002" }

    context "on create" do
      it "adds a validation error" do
        model = NullableUuidModel.create(uuid: v1_uuid)

        expect(model.errors).to be_of_kind(:uuid, :not_v4_uuid)
      end

      it "logs the error" do
        allow(TrackBallast.logger).to receive(:error)

        NullableUuidModel.create(uuid: v1_uuid)

        expect(TrackBallast.logger)
          .to have_received(:error).with(hash_including(class: "NullableUuidModel", uuid: v1_uuid))
      end

      it "adds a validation error if the object is newed up and then UUID set to v1" do
        model = NullableUuidModel.new
        expect(model).to be_valid

        model.uuid = v1_uuid

        expect(model).not_to be_valid
      end
    end

    context "on update" do
      it "saves the record" do
        model = NullableUuidModel.new
        model.uuid = v1_uuid
        model.save(validate: false)

        expect(model.save).to be_truthy
      end
    end
  end
end
