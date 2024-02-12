# frozen_string_literal: true

require "spec_helper"

require "track_ballast/stop_signal"

RSpec.describe TrackBallast::StopSignal do
  describe "extend usage" do
    it "has a lifecycle that allows stopping a job" do
      fake_job = Class.new do
        extend TrackBallast::StopSignal
      end

      # Default
      expect(fake_job.stopped?).to eq(false)

      fake_job.stop!

      expect(fake_job.stopped?).to eq(true)

      # Idempotent
      fake_job.stop!

      expect(fake_job.stopped?).to eq(true)

      fake_job.go!

      expect(fake_job.stopped?).to eq(false)

      # Idempotent
      fake_job.go!

      expect(fake_job.stopped?).to eq(false)
    end

    it "allows for multiple classes to share the same stop signal" do
      fake_job_1 = Class.new do
        extend TrackBallast::StopSignal

        def self.stop_signal_key
          "shared_key:stop"
        end
      end

      fake_job_2 = Class.new do
        extend TrackBallast::StopSignal

        def self.stop_signal_key
          "shared_key:stop"
        end
      end

      expect(fake_job_1.stopped?).to eq(false)
      expect(fake_job_2.stopped?).to eq(false)

      fake_job_1.stop!

      expect(fake_job_1.stopped?).to eq(true)
      expect(fake_job_2.stopped?).to eq(true)

      fake_job_1.go!

      expect(fake_job_1.stopped?).to eq(false)
      expect(fake_job_2.stopped?).to eq(false)
    end
  end

  describe "include usage" do
    it "has a lifecycle that allows stopping a model" do
      fake_model = Class.new do
        include TrackBallast::StopSignal

        attr_reader :id

        def initialize(id)
          @id = id
        end

        def stop_signal_key
          "#{self.class.name}:#{id}:stop"
        end
      end

      fake_model_1 = fake_model.new(1)
      fake_model_2 = fake_model.new(2)

      # Default
      expect(fake_model_1.stopped?).to eq(false)
      expect(fake_model_2.stopped?).to eq(false)

      fake_model_1.stop!

      expect(fake_model_1.stopped?).to eq(true)
      expect(fake_model_2.stopped?).to eq(false)

      # Idempotent
      fake_model_1.stop!

      expect(fake_model_1.stopped?).to eq(true)
      expect(fake_model_2.stopped?).to eq(false)

      fake_model_1.go!

      expect(fake_model_1.stopped?).to eq(false)
      expect(fake_model_2.stopped?).to eq(false)

      # Idempotent
      fake_model_1.go!

      expect(fake_model_1.stopped?).to eq(false)
      expect(fake_model_2.stopped?).to eq(false)
    end
  end

  describe "error handling" do
    it "raises a wrapped error when an error occurs while setting the stop signal" do
      fake_job = Class.new do
        extend TrackBallast::StopSignal
      end

      allow(TrackBallast.redis).to receive(:set).and_raise(Redis::CommandError)

      expect { fake_job.stop! }
        .to raise_error(TrackBallast::StopSignalError) do |error|
          expect(error.cause).to be_kind_of(Redis::CommandError)
        end
    end

    it "raises a wrapped error when an error occurs while removing the stop signal" do
      fake_job = Class.new do
        extend TrackBallast::StopSignal
      end

      allow(TrackBallast.redis).to receive(:del).and_raise(Redis::CommandError)

      expect { fake_job.go! }
        .to raise_error(TrackBallast::StopSignalError) do |error|
          expect(error.cause).to be_kind_of(Redis::CommandError)
        end
    end

    it "raises a wrapped error when an error occurs while checking the stop signal" do
      fake_job = Class.new do
        extend TrackBallast::StopSignal
      end

      allow(TrackBallast.redis).to receive(:exists).and_raise(Redis::CommandError)

      expect { fake_job.stopped? }
        .to raise_error(TrackBallast::StopSignalError) do |error|
          expect(error.cause).to be_kind_of(Redis::CommandError)
        end
    end
  end
end
