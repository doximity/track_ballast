[![CircleCI](https://dl.circleci.com/status-badge/img/gh/doximity/track_ballast/tree/master.svg?style=svg)](https://dl.circleci.com/status-badge/redirect/gh/doximity/track_ballast/tree/master)

# TrackBallast

TrackBallast contains small supporting units of Ruby to use with Rails.  It is named after [the small supporting stones that you see alongside railway tracks](https://www.scienceabc.com/pure-sciences/why-are-there-stones-train-ballast-alongside-railway-tracks.html).

None of these units are quite large enough to be a full Ruby gem on their own, but are yet highly reusable and useful in many Rails applications.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "track_ballast"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install track_ballast

If you wish to use features that rely on Redis, please set a Redis connection to `TrackBallast.redis`.

For Rails, you may wish to set up TrackBallast using an initializer, though **please note**, the default configuration may be appropriate.  Please see the `TrackBallast.redis` documentation for details.

```ruby
# config/initializers/track_ballast.rb

TrackBallast.redis = Redis.new(url: ENV["CUSTOM_REDIS_URL"])
```

## Usage

Please see [the code](https://github.com/doximity/track_ballast/tree/master/lib/track_ballast) and [documentation](https://www.rubydoc.info/gems/track_ballast) for individual units.

You may `require` the entirety of `track_ballast`:

```ruby
require "track_ballast/all"
```

...or, in your `Gemfile`:

```ruby
gem "track_ballast", require: "track_ballast/all"
```

Alternatively, only require each desired unit:

```ruby
require "track_ballast/callable"

class MyService
  extend TrackBallast::Callable
end
```

```ruby
require "track_ballast/uuid_management"

class MyModel < ApplicationRecord
  include TrackBallast::UuidManagement
end
```

## Roadmap

Please see [the Milestones on GitHub](https://github.com/doximity/track_ballast/milestones?direction=asc&sort=title&state=open).

## Development

You'll need [Redis](https://redis.io/docs/getting-started/) and [Ruby](https://www.ruby-lang.org/en/downloads/) installed.  Please ensure both are set up before continuing.

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

To allow for easy use of individual features of this library, please ensure specs run independently.  For example:

```shell
find spec -name '*_spec.rb' -exec bundle exec rspec {} \;
```

## Contributing

1. See [CONTRIBUTING.md](./CONTRIBUTING.md)
2. Fork it ( https://github.com/doximity/track_ballast/fork )
3. Create your feature branch (`git checkout -b my-new-feature`)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create a new Pull Request

## License

`track_ballast` is licensed under an Apache 2 license. Contributors are required to sign a contributor license agreement. See LICENSE.txt and CONTRIBUTING.md for more information.
