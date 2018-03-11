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
    end
  end
end
