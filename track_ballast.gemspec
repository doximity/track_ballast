# frozen_string_literal: true

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "track_ballast/version"

Gem::Specification.new do |spec|
  spec.name = "track_ballast"
  spec.version = TrackBallast::VERSION
  spec.authors = ["Benjamin Oakes"]
  spec.email = ["boakes@doximity.com"]

  spec.summary = "Small supporting units of Ruby to use with Rails"
  spec.homepage = "https://github.com/doximity/track_ballast"
  spec.license = "APACHE-2.0"
  spec.required_ruby_version = Gem::Requirement.new(">= 3.0.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/doximity/track_ballast/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path("..", __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.executables = []
  spec.require_paths = ["lib"]

  spec.add_dependency "activerecord", ">= 6.1", "< 8.0"
  spec.add_dependency "activesupport", ">= 6.1", "< 8.0"
  spec.add_dependency "redis", ">= 4.8", "< 6.0"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec_junit_formatter"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "standard"
  spec.add_development_dependency "yard"
end
