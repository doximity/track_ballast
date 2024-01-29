# frozen_string_literal: true

require "track_ballast/callable"

RSpec.describe TrackBallast::Callable do
  it "can be called without keyword arguments" do
    divide_by_two_class = Class.new do
      extend TrackBallast::Callable

      def initialize(int)
        @int = int
      end

      def call
        @int / 2
      end
    end

    expect(divide_by_two_class.call(10)).to eq(5)
  end

  it "can be called with keyword arguments" do
    keyword_class = Class.new do
      extend TrackBallast::Callable

      def initialize(a:, heinz:)
        @a = a
        @heinz = heinz
      end

      def call
        "#{@a} #{@heinz}"
      end
    end

    expect(keyword_class.call(a: 1, heinz: 57)).to eq("1 57")
  end

  it "can be called with a block" do
    block_class = Class.new do
      extend TrackBallast::Callable

      def call(&block)
        "#{block.call}!"
      end
    end

    expect(block_class.call { "BBQ" }).to eq("BBQ!")
  end

  it "accepts all possible parameters" do
    kitchen_sink_class = Class.new do
      extend TrackBallast::Callable

      def initialize(a, heinz:)
        @a = a
        @heinz = heinz
      end

      def call(&block)
        "#{@a} #{@heinz} #{block.call}!"
      end
    end

    expect(kitchen_sink_class.call(1, heinz: 57) { "BBQ" }).to eq("1 57 BBQ!")
  end
end
