# frozen_string_literal: true

require 'yarnlock/version'

require 'yarnlock/config'
require 'yarnlock/entry'
require 'yarnlock/entry/collection'
require 'yarnlock/js_executor'

require 'json'

module Yarnlock
  def self.config
    @config ||= Config.new
  end

  def self.configure
    yield config
  end

  def self.parse(yarnlock)
    json_string = JsExecutor.execute 'parse', yarnlock
    parsed = JSON.parse json_string

    raise "An error was occurred when parsing yarn.lock: #{parsed}" unless parsed.is_a? Hash
    raise "Could not parse yarn.lock: #{parsed['reason']}" if parsed['type'] == 'failure'

    return parsed['object'] unless config.return_collection

    Entry::Collection.parse parsed['object']
  end

  def self.stringify(object)
    json_string = JsExecutor.execute 'stringify', JSON.generate(object)
    parsed = JSON.parse json_string

    raise "An error was occurred when stringing object: #{parsed}" unless parsed.is_a? Hash
    raise "Could not stringing object: #{parsed['reason']}" if parsed['type'] == 'failure'

    parsed['yarnlock']
  end

  def self.load(file)
    parse File.read(file)
  end
end
