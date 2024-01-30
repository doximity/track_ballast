# frozen_string_literal: true

require "active_support"
require "active_support/core_ext"

module TrackBallast
  # A module for building callable service classes where exactly one method
  # will ever be called and only the return value of that method matters, not
  # the class instance itself.
  #
  # == Usage
  #
  # - Define +initialize+ with the desired arguments
  # - Define +call+ with the desired logic
  # - Extend the class with this module
  #
  # == Example
  #
  #     class DivideByTwo
  #       extend TrackBallast::Callable
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
    def call(...)
      new(...).call { yield }
    end
  end
end
