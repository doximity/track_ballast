# frozen_string_literal: true

require "active_support"
require "active_support/core_ext"

module TrackBallast
  # Module for building callable service classes where exactly one method will
  # ever be called and only the return value of that method matters, not the
  # class instance itself.
  #
  # Usage:
  #
  #     class DivideByTwo
  #       extend Callable
  #
  #       def initialize(int)
  #         @int = int
  #       end
  #
  #       def call
  #         int / 2
  #       end
  #
  #       private
  #
  #       attr_reader :int
  #     end
  #
  #     DivideByTwo.call(10) # => 5
  module Callable
    def call(*args, **kwargs, &block)
      if kwargs.present?
        new(*args, **kwargs).call(&block)
      else
        new(*args).call(&block)
      end
    end
  end
end
