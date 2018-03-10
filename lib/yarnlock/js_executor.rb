# frozen_string_literal: true

module Yarnlock
  module JsExecutor
    def self.execute(script, stdin)
      IO.popen(script_path(script), 'r+') do |io|
        io.puts stdin
        io.close_write
        io.gets
      end
    end

    def self.script_path(script)
      "#{Yarnlock.config.node_path} #{Yarnlock.config.script_dir}/#{script}"
    end
  end
end
