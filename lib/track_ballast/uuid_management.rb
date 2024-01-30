# frozen_string_literal: true

require "securerandom"

require "active_record"
require "active_support"
require "active_support/core_ext"
require "track_ballast/logger"

module TrackBallast
  module UuidManagement
    extend ActiveSupport::Concern

    REGEXP_UUID_V4 = /^[0-9A-F]{8}-[0-9A-F]{4}-4[0-9A-F]{3}-[89AB][0-9A-F]{3}-[0-9A-F]{12}$/i

    included do
      with_options if: :uuid_exists? do
        after_initialize :uuid_generate, if: :new_record?
        before_validation :uuid_generate, on: :create

        validate :v4_uuid, on: :create
        with_options unless: :uuid_nullable? do
          validates :uuid, presence: true, length: { is: 36 }
        end
      end
    end

    private

    def v4_uuid
      return if uuid.match(REGEXP_UUID_V4)

      TrackBallast.logger.tagged("invalid-uuid") do |logger|
        logger.error(class: self.class.name, uuid: uuid, caller: caller.join("\n"))
      end

      errors.add :base, "Only V4 UUIDs are permitted"
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
