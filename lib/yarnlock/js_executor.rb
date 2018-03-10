# frozen_string_literal: true

module Yarnlock
  module JsExecutor
    def self.execute(script, stdin)
      IO.popen("node #{dir}/#{script}", 'r+') do |io|
        io.puts stdin
        io.close_write
        io.gets
      end
    end

    def self.dir
      return @dir unless @dir.nil?
      @dir = File.join File.dirname(File.dirname(__dir__)), 'scripts'
    end
  end
end
