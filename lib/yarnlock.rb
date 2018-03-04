# frozen_string_literal: true

require 'yarnlock/version'
require 'json'

module Yarnlock
  def self.parse(yarnlock)
    json_string = execute_script 'parse', yarnlock
    parsed = JSON.parse json_string
    raise "An error was occurred when parsing yarn.lock: #{parsed}" unless parsed.is_a? Hash
    raise "Could not parse yarn.lock: #{parsed['reason']}" unless parsed['type'] == 'success'
    parsed['object']
  end

  def self.stringify(object)
    json_string = execute_script 'stringify', JSON.generate(object)
    parsed = JSON.parse json_string
    raise "An error was occurred when stringing object: #{parsed}" unless parsed.is_a? Hash
    raise "Could not stringing object: #{parsed['reason']}" unless parsed['type'] == 'success'
    parsed['yarnlock']
  end

  def self.load(file)
    parse File.read(file)
  end

  def self.execute_script(script, stdin)
    IO.popen("node #{script_dir}/#{script}", 'r+') do |io|
      io.puts stdin
      io.close_write
      io.gets
    end
  end

  def self.script_dir
    return @script_dir unless @script_dir.nil?
    @script_dir = File.join File.dirname(__dir__), '/scripts'
  end

  private_class_method :execute_script, :script_dir
end
