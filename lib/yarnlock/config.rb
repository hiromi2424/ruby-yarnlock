# frozen_string_literal: true

module Yarnlock
  class Config
    attr_accessor :node_path, :script_dir, :return_collection

    def initialize
      @node_path = 'node'
      @script_dir = File.expand_path '../../scripts', __dir__
      @return_collection = true
    end
  end
end
