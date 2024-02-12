# frozen_string_literal: true

require "track_ballast/redis"

RSpec.describe TrackBallast do
  describe ".redis" do
    around do |example|
      original_redis = TrackBallast.redis

      example.run
    ensure
      TrackBallast.redis = original_redis
    end

    it "returns the configured logger" do
      redis = double
      TrackBallast.redis = redis

      expect(TrackBallast.redis).to eq(redis)
    end

    it "uses the Rails logger when no logger is configured" do
      url = "redis://localhost:6379/1"
      TrackBallast.redis = nil
      expect(ENV["REDIS_URL"]).not_to eq(url)
      stub_const("ENV", "REDIS_URL" => url)

      expect(TrackBallast.redis.id).to eq(url)
    end

    it "raises an error when a redis is not configured and REDIS_URL is not present" do
      TrackBallast.redis = nil
      stub_const("ENV", {})

      expect { TrackBallast.redis }.to raise_error(TrackBallast::NoRedisError)
    end
  end
end
