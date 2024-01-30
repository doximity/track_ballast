# frozen_string_literal: true

require "active_record"
require "track_ballast/uuid_management"

class CreateNullableUuidModelsTable < ActiveRecord::Migration[7.1]
  def change
    create_table :nullable_uuid_models do |table|
      table.string :uuid, null: true
    end
  end
end

class CreateNonNullableUuidModelsTable < ActiveRecord::Migration[7.1]
  def change
    create_table :non_nullable_uuid_models do |table|
      table.string :uuid, null: false
    end
  end
end

class NullableUuidModel < ActiveRecord::Base
  include TrackBallast::UuidManagement
end

class NonNullableUuidModel < ActiveRecord::Base
  include TrackBallast::UuidManagement
end
