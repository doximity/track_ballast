# frozen_string_literal: true

require "active_record"
require "active_support"
require "active_support/core_ext"

module TrackBallast
  module UuidManagement
    extend ActiveSupport::Concern

    included do
      with_options if: :uuid_exists? do
        before_validation :uuid_generate, on: :create

        with_options unless: :uuid_nullable? do
          validates :uuid, presence: true, length: { is: 36 }
        end
      end
    end

    private

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
      self.uuid = SecureRandom.uuid if uuid.blank?
    end
  end
end
