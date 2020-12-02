# frozen_string_literal: true

module Yarnlock
  class Entry
    module Collection
      def self.parse(raw_entries)
        raw_entries.map do |pattern, raw_entry|
          Entry.parse pattern, raw_entry
        end.extend(self)
      end

      def package_with_versions
        each_with_object({}) do |entry, packages|
          packages[entry.package] ||= []
          packages[entry.package] << entry
        end
      end

      def highest_version_packages
        each_with_object({}) do |entry, packages|
          packages[entry.package] = [entry, packages[entry.package]].compact.max_by(&:version)
        end
      end

      def lowest_version_packages
        each_with_object({}) do |entry, packages|
          packages[entry.package] = [entry, packages[entry.package]].compact.min_by(&:version)
        end
      end

      def as_json(_options = {})
        each_with_object({}) do |entry, entries|
          entries.merge! entry.to_h
        end
      end

      def to_json(*options)
        as_json(*options).to_json(*options)
      end
    end
  end
end
