# frozen_string_literal: true

module Yarnlock
  class Config
    attr_accessor :script_dir, :node_path, :return_collection

    def initialize
      @script_dir = File.expand_path '../../scripts', __dir__
      @node_path = 'node'
      @return_collection = true
    end
  end
end
