# frozen_string_literal: true

module TrackBallast
  class << self
    # Internal logger for +TrackBallast+.
    #
    # This defaults to +Rails.logger+.  This +logger+ method may be removed in
    # the future if we determine that +Rails.logger+ is more sensible given the
    # focus of the library.  Please do not use +TrackBallast.logger+ outside of
    # this gem.
    #
    # @!visibility private
    # @return [ActiveSupport::TaggedLogging] a tagged logger
    attr_accessor :logger
  end
end

if defined?(Rails)
  TrackBallast.logger = Rails.logger
end
