# frozen_string_literal: true

require 'semantic'

module Yarnlock
  class Entry
    attr_accessor :package, :version_ranges, :resolved, :dependencies
    attr_reader :version

    def self.parse(pattern, entry)
      new.parse pattern, entry
    end

    def parse(pattern, entry)
      self.version_ranges = []
      pattern.split(', ').each do |package_version|
        self.package, version_range = package_version.split(/(?!^)@/)
        version_ranges << version_range
      end

      self.version = entry['version']
      self.resolved = entry['resolved']
      self.dependencies = entry['dependencies']

      self
    end

    def initialize(attributes = {})
      attributes.each do |key, val|
        send "#{key}=", val
      end
    end

    def version=(version)
      @version = version.is_a?(String) ? Semantic::Version.new(version) : version
    end

    def to_h
      pattern = version_ranges.map do |version_range|
        "#{package}@#{version_range}"
      end.join(', ')
      {
        pattern => {
          'version' => version.to_s,
          'resolved' => resolved,
          'dependencies' => dependencies
        }.compact
      }
    end

    def as_json(_options = {})
      to_h
    end

    def to_json(*options)
      as_json(*options).to_json(*options)
    end

    def ==(other)
      other.is_a?(self.class) && other.to_h == to_h
    end

    def eql?(other)
      self == other
    end

    def hash
      to_h.hash
    end
  end
end
