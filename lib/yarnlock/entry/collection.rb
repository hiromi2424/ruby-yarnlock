# frozen_string_literal: true

module Yarnlock
  class Entry
    class Collection < Hash
      def self.parse(raw_entries)
        collection = new
        raw_entries.each do |pattern, raw_entry|
          entry = Yarnlock::Entry.parse pattern, raw_entry
          collection[entry.package] ||= {}
          collection[entry.package][entry.version] = entry
        end
        collection
      end

      def as_json(_options = {})
        entries = {}
        each_value do |versions|
          versions.each_value do |entry|
            entries.merge! entry.to_h
          end
        end
        entries
      end

      def to_json(*options)
        as_json(*options).to_json(*options)
      end
    end
  end
end
