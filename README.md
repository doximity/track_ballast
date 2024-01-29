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

## Usage

Please see the code and documentation for individual units.  Please `require` and use each unit directly.

Examples:

```ruby
require "track_ballast/callable"

class MyService
  include TrackBallast::Callable
end
```

```ruby
require "track_ballast/uuid_management"

class MyModel < ApplicationModel
  include TrackBallast::UuidManagement
end
```

## Roadmap

Please see [the Milestones on GitHub](https://github.com/doximity/track_ballast/milestones?direction=asc&sort=title&state=open).

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. See [CONTRIBUTING.md](./CONTRIBUTING.md)
2. Fork it ( https://github.com/doximity/track_ballast/fork )
3. Create your feature branch (`git checkout -b my-new-feature`)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create a new Pull Request

## License

`track_ballast` is licensed under an Apache 2 license. Contributors are required to sign a contributor license agreement. See LICENSE.txt and CONTRIBUTING.md for more information.
