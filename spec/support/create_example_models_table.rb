# frozen_string_literal: true

class CreateExampleModelsTable < ActiveRecord::Migration[6.1]
  def change
    create_table :example_models do |table|
      table.string :uuid
    end
  end
end
