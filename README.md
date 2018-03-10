# Ruby-Yarnlock

[![Gem Version](https://badge.fury.io/rb/yarnlock.svg)](https://badge.fury.io/rb/yarnlock)
[![Build Status](https://travis-ci.org/hiromi2424/ruby-yarnlock.svg?branch=master)](https://travis-ci.org/hiromi2424/ruby-yarnlock)

Thin wrapper of [@yarnpkg/lockfile](https://yarnpkg.com/ja/package/@yarnpkg/lockfile) for Ruby.

Note that this is NOT a resolver of every package.
It means parsed object does not contain any package.json info of dependencies!

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'yarnlock'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install yarnlock

Also add `@yarnpkg/lockfile` to your yarn dev dependency:

    $ yarn add @yarnpkg/lockfile --dev


## Usage

```ruby
require 'yarnlock'
# Parse string as in yarn.lock:
Yarnlock.parse 'yarn_lock_text'
# Returns Hash object like: {"@yarnpkg/lockfile@^1.0.0"=>{"version"=>"1.0.0", "resolved"=>"https://registry.yarnpkg.com/@yarnpkg/lockfile/-/lockfile-1.0.0.tgz#33d1dbb659a23b81f87f048762b35a446172add3"}}

# Load from file path:
Yarnlock.load 'yarn.lock'

# Stringify parsed object from yarn.lock
Yarnlock.stringify parsed_hash
```

You can configure paths for Node.js(`'node'` by default) and JS scripts dir(`'{package root}/scripts'` by default).

```ruby
Yarnlock.configure do |config|
  config.script_dir = '/path/to/my/dir'
  config.node_path = '/usr/local/bin/node'
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hiromi2424/ruby-yarnlock. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Ruby-Yarnlock project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/hiromi2424/ruby-yarnlock/blob/master/CODE_OF_CONDUCT.md).
