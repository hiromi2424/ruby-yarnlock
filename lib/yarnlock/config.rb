# frozen_string_literal: true

module Yarnlock
  class Config
    attr_accessor :script_dir, :node_path

    def initialize
      @script_dir = File.expand_path '../../scripts', __dir__
      @node_path = 'node'
    end
  end
end
