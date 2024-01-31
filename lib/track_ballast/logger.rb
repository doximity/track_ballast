# frozen_string_literal: true

require "track_ballast/error"

module TrackBallast
  # Raised when logging is attempted without a configured logger
  class NoLoggerError < Error; end

  class << self
    # @!visibility private
    attr_writer :logger

    # Internal logger for +TrackBallast+.
    #
    # This defaults to +Rails.logger+.  This +logger+ method may be removed in
    # the future if we determine that +Rails.logger+ is more sensible given the
    # focus of the library.  Please do not use +TrackBallast.logger+ outside of
    # this gem.
    #
    # @!visibility private
    # @return [ActiveSupport::TaggedLogging] a tagged logger
    def logger
      if @logger
        @logger
      elsif defined?(Rails)
        # This will short-circuit to be `@logger` on future runs
        @logger = Rails.logger
      else
        raise NoLoggerError, "TrackBallast.logger is not configured"
      end
    end
  end
end
