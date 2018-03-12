# Ruby-Yarnlock

[![Gem Version](https://badge.fury.io/rb/yarnlock.svg)](https://badge.fury.io/rb/yarnlock)
[![Build Status](https://travis-ci.org/hiromi2424/ruby-yarnlock.svg?branch=master)](https://travis-ci.org/hiromi2424/ruby-yarnlock)

Thin wrapper of [@yarnpkg/lockfile](https://yarnpkg.com/en/package/@yarnpkg/lockfile) for Ruby.

Note that this is NOT a resolver of every package.
It means parsed object does not contain any `package.json` info of dependencies!

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
parsed = Yarnlock.parse 'yarn_lock_text'

# Load from file path:
parsed = Yarnlock.load 'yarn.lock'

# Stringify parsed object from yarn.lock
Yarnlock.stringify parsed
```

### Parsed object structure

`Yarnlock.parse` returns `Yarnlock::Entry::Collection` object that is actually extends `Hash` and is holding each entries defined at `yarn.lock`.

That hash has 3 dimension, such like:

```ruby
parsed['@yarnpkg/lockfile']['1.0.0'] = Yarnlock::Entry.new
```

The key of 1st level is the package name that is found on [Yarn repository](https://yarnpkg.com), can be used for dependency specification in `package.json`.
The key of 2nd level is the resolved version for range of versions.
The value is `Yarnlock.Entry` object that represents a entry of `yarn.lock`.

`Yarnlock.Entry` is a pure class that holds parsed information from a entry. You can access attribute to get information what you need:

- `package` `[String]` The package name. Same as 1st level key of `Yarnlock::Entry::Collection`.
- `version` `[String]` Resolved version. Same as 2nd level key of `Yarnlock::Entry::Collection`.
- `version_ranges` `[Array]` Version ranges, this holds multiple ranges like `['^2.1.0', '^2.1.1']`.
  - You can see like `"@yarnpkg/lockfile@^1.0.0":` in `yarn.lock`, range of versions is `^1.0.0` of that, specified by `*dependencies` at `package.json` and its sub dependencies.
- `resolved` `[String]` Resolved registry location for tar ball.
- `dependencies` `[Hash]` Sub dependencies keyed by package name and valued by version range.

### Options

You can configure some options to change behavior like:

```ruby
Yarnlock.configure do |config|
  config.node_path = '/usr/local/bin/node'
  config.script_dir = '/path/to/my/dir'
  config.return_collection = false
end
```

- `node_path` `[String]` (`'node'` by default) The executable path for Node.js. Since yarn requires Node.js, this gem does not use any javascript executor gem, directly use `node` command on your local machine. You can use other path to use different version of Node.js.
- `script_dir` `[String]` (`'{package root}/scripts'` by default) The directory for javascripts to execute `@yarnpkg/lockfile` API. You can override this dir to execute your custom scripts if needed.
- `return_collection` `[boolean]` (`true` by default) Specify whether return value of `Yarnlock.parse` is collection object provided by this gem or pure JSON value from `@yarnpkg/lockfile` API represented as `Hash`.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hiromi2424/ruby-yarnlock. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Ruby-Yarnlock project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/hiromi2424/ruby-yarnlock/blob/master/CODE_OF_CONDUCT.md).
