# frozen_string_literal: true

module Yarnlock
  class Entry
    attr_accessor :package, :version_ranges, :version, :resolved, :dependencies

    def self.parse(pattern, entry)
      new.parse pattern, entry
    end

    def parse(pattern, entry)
      @version_ranges = []
      pattern.split(', ').each do |package_version|
        @package, version_range = package_version.split(/(?!^)@/)
        @version_ranges << version_range
      end

      @version = entry['version']
      @resolved = entry['resolved']
      @dependencies = entry['dependencies']

      self
    end

    def to_h
      pattern = version_ranges.map do |version_range|
        "#{package}@#{version_range}"
      end.join(', ')
      {
        pattern => {
          'version' => version,
          'resolved' => resolved,
          'dependencies' => dependencies
        }
      }
    end

    def ==(other)
      other.is_a?(self.class) && other.to_h == to_h
    end
  end
end
