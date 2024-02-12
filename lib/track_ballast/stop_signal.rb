# frozen_string_literal: true

require "track_ballast/redis"

module TrackBallast
  class StopSignalError < StandardError; end

  # +StopSignal+ is a module that provides a way to stop a process while it is
  # running.
  #
  # It uses Redis to store the stop signal.  Please see +TrackBallast.redis+
  # for more details.
  #
  # When the stop signal is set, the client process will stop the next time the
  # process manually checks the +stopped?+ method.
  #
  # == Usage
  #
  # +StopSignal+ can be used via +extend+ or +include+.
  #
  # === Extend
  #
  # - Extend the module in your class
  # - Call +stopped?+ to check if the stop signal is set, for example: at the
  #   beginning of the +perform+ method in a job class.
  # - If desired, add an implementation of the +stop_signal_key+ method.  This
  #   can be useful for stopping multiple classes with the same stop signal.  For
  #   example: multiple related jobs.  The default implementation is to use the
  #   class name.
  #
  # Then, from another process, you can manipulate the stop signal:
  #
  # - Call +YourClass.stop!+ to set the stop signal
  # - Call +YourClass.go!+ to remove the stop signal
  #
  # ==== Example
  #
  #     class YourJob < ApplicationJob
  #       extend TrackBallast::StopSignal
  #
  #       def perform
  #         return if self.class.stopped?
  #
  #         # Process your job here
  #       end
  #
  #       # Optional:
  #       #
  #       #     def self.stop_signal_key
  #       #       "custom_stop_signal_key:stop"
  #       #     end
  #     end
  #
  # === Include
  #
  # - Include the module in your class
  # - Call +stopped?+ to check if the stop signal is set, for example: at the
  #   beginning of the +perform+ method in a job class.
  # - If desired, add an implementation of the +stop_signal_key+ method.  This
  #   can tie the stop signal to a specific instance of the class, as shown in
  #   the example below.
  #
  # Then, from another process, you can manipulate the stop signal:
  #
  # - Call +your_model_instance.stop!+ to set the stop signal
  # - Call +your_model_instance.go!+ to remove the stop signal
  #
  # ==== Example
  #
  #     class YourModel < ApplicationRecord
  #       include TrackBallast::StopSignal
  #
  #       # Optional, but recommended for usage via `include`
  #       def stop_signal_key
  #         "#{self.class.name}:#{id}:stop"
  #       end
  #     end
  #
  #     class YourModelService
  #       def initialize(your_model_instance)
  #         @your_model_instance = your_model_instance
  #       end
  #
  #       def call
  #         return if your_model_instance.stopped?
  #
  #         # Process `your_model_instance` here
  #       end
  #     end
  #
  module StopSignal
    # Set the stop signal
    #
    # @return [Boolean] +true+ if the stop signal was set
    # @raise [StopSignalError] if an error occurred while setting the stop signal
    def stop!
      redis.set(stop_signal_key, true)

      true
    rescue Redis::CommandError
      raise StopSignalError
    end

    # Remove the stop signal
    #
    # @return [Boolean] +true+ if the stop signal was removed
    # @raise [StopSignalError] if an error occurred while removing the stop signal
    def go!
      redis.del(stop_signal_key)

      true
    rescue Redis::CommandError
      raise StopSignalError
    end

    # Check if the stop signal is set
    #
    # @raise [StopSignalError] if an error occurred while checking the stop signal
    def stopped?
      redis.exists(stop_signal_key).positive?
    rescue Redis::CommandError
      raise StopSignalError
    end

    # The key used to store the stop signal.
    #
    # It defaults to the class name plus ":stop".
    #
    # This can be overridden to provide a custom key as described in the
    # +StopSignal+ module documentation.
    #
    # @return [String] the key used to store the stop signal
    def stop_signal_key
      "#{name}:stop"
    end

    private

    def redis
      TrackBallast.redis
    end
  end
end
