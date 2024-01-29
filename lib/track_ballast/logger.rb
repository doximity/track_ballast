# frozen_string_literal: true

module TrackBallast
  class << self
    attr_accessor :logger
  end
end

if defined?(Rails)
  TrackBallast.logger = Rails.logger
end
