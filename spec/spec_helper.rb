# frozen_string_literal: true

require "bundler/setup"
require "track_ballast"

require "active_record"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before :suite do
    TrackBallast.logger = ActiveSupport::TaggedLogging.new(Logger.new(StringIO.new))
  end

  config.before do
    # TODO: This may be unnecessary in some specs.  If that becomes a
    # noticeable slowdown, consider options to only set up ActiveRecord when
    # needed.
    ActiveRecord::Base.establish_connection(
      adapter: "sqlite3",
      database: ":memory:" # https://www.sqlite.org/inmemorydb.html
    )
  end
end
