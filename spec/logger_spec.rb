# frozen_string_literal: true

require "track_ballast/logger"

RSpec.describe TrackBallast do
  describe ".logger" do
    around do |example|
      original_logger = TrackBallast.logger

      example.run
    ensure
      TrackBallast.logger = original_logger
    end

    it "returns the configured logger" do
      logger = double
      TrackBallast.logger = logger

      expect(TrackBallast.logger).to eq(logger)
    end

    it "uses the Rails logger when no logger is configured" do
      TrackBallast.logger = nil
      logger = double
      stub_const("Rails", double(logger: logger))

      expect(TrackBallast.logger).to eq(logger)
    end

    it "raises an error when a logger is not configured and Rails is not present" do
      TrackBallast.logger = nil
      hide_const("Rails")

      expect { TrackBallast.logger }.to raise_error(TrackBallast::NoLoggerError)
    end
  end
end
