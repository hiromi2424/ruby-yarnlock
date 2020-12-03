# Ruby-Yarnlock

[![Gem Version](https://badge.fury.io/rb/yarnlock.svg)](https://badge.fury.io/rb/yarnlock)
[![Build Status](https://travis-ci.com/hiromi2424/ruby-yarnlock.svg?branch=master)](https://travis-ci.com/hiromi2424/ruby-yarnlock)

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

# Stringify parsed object from yarn.lock
string = Yarnlock.stringify parsed

# Load from file path:
parsed = Yarnlock.load 'yarn.lock'
```

### Parsed object structure

Original `parse` function of `@yarnpkg/lockfile` returns pure JSON object in javascript context, so that this library parse JSON and convert it to ruby object for general purpose.

`Yarnlock.parse` returns just an `array` containing each entries defined at `yarn.lock`. Entries are represented as `Yarnlock::Entry` instances. Additionally array extends `Yarnlock::Entry::Collection` module to provide some useful enumeration and JSON serialization.

## API

### `Yarnlock::Entry::Collection`

is a module that is used for `Yarnlock.stringify` to make `string` as same as `yarn.lock`. In other words, You can modify entries and generate customized `yarn.lock` programmatically. Collection is just a instance of `Array`:

```ruby
yarnlock = Yarnlock.load 'yarn.lock'
# returns like '@yarnpkg/lockfile' => [<Yarnlock::Entry>]
yarnlock.group_by(&:package)
# returns like ["resolve@1.1.7", "resolve@1.3.3"]
yarnlock.map { |entry| "#{entry.package}@#{entry.version}" }.sort
```

Also it provides an enumeration method to retrieve entries for each packages easily:

#### `package_with_versions` `[Hash<String, <String, Yarnlock::Entry>>]`

returns 2 dimensional hash for iterate package with every resolved versions.

- The key of 1st level is the package name that is found on [Yarn repository](https://yarnpkg.com), can be used for dependency specification in package.json.
- The key of 2nd level is the resolved version for range of versions. It is parsed as `Semantic::Version`
- The value is `Yarnlock.Entry` instance.

For example:

```ruby
yarnlock = Yarnlock.load 'yarn.lock'
yarnlock.package_with_versions.each do |package, versions|
  puts package # '@yarnpkg/lockfile'
  versions.each do |version, entry|
    puts version # <Semantic::Version:0x007fe286056110 @major=1, @minor=0, @patch=0, @pre=nil, @build=nil, @version="1.0.0">
    puts entry.resolved # 'https://registry.yarnpkg.com/@yarnpkg/lockfile/-/lockfile-1.0.0.tgz#33d1dbb659a23b81f87f048762b35a446172add3'
  end
end
```

#### `highest_version_packages` `[Hash<String, Yarnlock::Entry>]`

returns hash keyed by package, valued by entry. Since `yarn install` command will install highest resolved version of each package, You can take such package + version pair like:

```ruby
yarnlock = Yarnlock.load 'yarn.lock'
yarnlock.highest_version_packages.each do |package, entry|
  puts package # '@yarnpkg/lockfile'
  puts entry.version # <Semantic::Version:0x007fe286056110 @major=1, @minor=0, @patch=0, @pre=nil, @build=nil, @version="1.0.0">
  puts entry.resolved # 'https://registry.yarnpkg.com/@yarnpkg/lockfile/-/lockfile-1.0.0.tgz#33d1dbb659a23b81f87f048762b35a446172add3'
end
```

### `Yarnlock::Entry`

is a pure class that holds parsed information from a entry. You can access attribute to get information what you need:

- `package` `[String]` The package name.
- `version` `[Semantic::Version]` Resolved version. This is not a just string but a `Semantic::Version` object to useful for compare for. See  [jlindsey/semantic: Ruby Semantic Version class](https://github.com/jlindsey/semantic/) for details.
- `version_ranges` `[Array]` Version ranges, this holds multiple ranges like `['^2.1.0', '^2.1.1']`.
  - You can see like `"@yarnpkg/lockfile@^1.0.0":` in `yarn.lock`, range of versions is `^1.0.0` of that, specified by `*dependencies` at `package.json` and its sub dependencies.
- `resolved` `[String]` Resolved registry location for tar ball.
- `dependencies` `[Hash]` Sub dependencies keyed by package name and valued by version range.

## Options

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
