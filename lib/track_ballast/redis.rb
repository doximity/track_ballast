# frozen_string_literal: true

require "redis"
require "track_ballast/error"

module TrackBallast
  # Raised when Redis access is attempted without a configured Redis connection.
  class NoRedisError < Error; end

  class << self
    attr_writer :redis

    # Internal Redis connection for +TrackBallast+.
    #
    # It defaults to the Redis instance configured by the +REDIS_URL+
    # environment variable.
    #
    # @return [Redis] a Redis connection
    def redis
      if @redis
        @redis
      elsif ENV["REDIS_URL"]
        # This will short-circuit to be `@redis` on future runs
        @redis = Redis.new(url: ENV["REDIS_URL"])
      else
        raise NoRedisError, "TrackBallast.redis is not configured"
      end
    end
  end
end
