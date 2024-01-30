# frozen_string_literal: true

class CreateUuidModelsTable < ActiveRecord::Migration[7.1]
  def change
    create_table :uuid_models do |table|
      table.string :uuid
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

class UuidModel < ActiveRecord::Base
  include TrackBallast::UuidManagement
end

class NonNullableUuidModel < ActiveRecord::Base
  include TrackBallast::UuidManagement
end
