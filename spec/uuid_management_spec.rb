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

  it "generates a UUID before validation" do
    model = UuidModel.new
    model.uuid = nil
    expect(model.uuid).not_to be

    model.valid?

    expect(model.uuid).to be
  end
end
