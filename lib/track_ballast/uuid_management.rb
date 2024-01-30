# frozen_string_literal: true

require "securerandom"

require "active_record"
require "active_support"
require "active_support/core_ext"
require "track_ballast/logger"

module TrackBallast
  # Manage a +uuid+ column alongside an autoincrementing +id+ column for an
  # +ActiveRecord+ model.
  #
  # == Additional Features
  #
  # - Adds presence validation if the +uuid+ column is non-nullable
  # - Enforces v4 UUIDs at creation time and logs violations with the
  #   +invalid-uuid+ tag
  #
  # == Usage
  #
  # === Adding a Column
  #
  # Add a +uuid+ column to your model such that it can be written as a string.
  #
  # Suggested:
  #
  #     t.string "uuid", limit: 36, null: false, unique: true
  #
  # Alternatively, for MySQL, consider using a binary column:
  #
  #     t.binary "uuid", limit: 16, null: false, unique: true
  #
  # ...and define the +uuid+ attribute using the +mysql-binuuid-rails+ gem:
  #
  #     attribute :uuid, MySQLBinUUID::Type.new
  #
  # This has performance and storage space benefits, but please note that this
  # may increase the difficulty of working with this column outside of Rails.
  #
  # Both forms of UUID column are acceptable and left as a decision for the
  # implementor.
  #
  # === Include the module
  #
  # After adding the column, simply +include+ the module:
  #
  #     class MyModel < ApplicationRecord
  #       include TrackBallast::UuidManagement
  #     end
  #
  module UuidManagement
    extend ActiveSupport::Concern

    included do
      with_options if: :uuid_exists? do
        after_initialize :uuid_generate, if: :new_record?
        before_validation :uuid_generate, on: :create

        validate :v4_uuid, on: :create
        with_options unless: :uuid_nullable? do
          validates :uuid, presence: true, length: {is: 36}
        end
      end
    end

    private

    REGEXP_UUID_V4 = /^[0-9A-F]{8}-[0-9A-F]{4}-4[0-9A-F]{3}-[89AB][0-9A-F]{3}-[0-9A-F]{12}$/i

    def v4_uuid
      return if uuid.match(REGEXP_UUID_V4)

      TrackBallast.logger.tagged("invalid-uuid") do |logger|
        logger.error(class: self.class.name, uuid: uuid, caller: caller.join("\n"))
      end

      errors.add :uuid, :not_v4_uuid, message: "is not a v4 UUID"
    end

    def uuid_exists?
      !uuid_column.nil?
    end

    def uuid_nullable?
      uuid_column.null
    end

    def uuid_column
      self.class.columns.find { |column| column.name == "uuid" }
    end

    def uuid_generate
      return unless try(:uuid).blank?

      self.uuid = SecureRandom.uuid
    end
  end
end
