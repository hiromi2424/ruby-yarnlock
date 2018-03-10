# frozen_string_literal: true

require 'bundler/setup'
require 'yarnlock'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.around :example do |example|
    # Restore default config values
    config_methods = Yarnlock::Config.instance_methods - Object.instance_methods
    config_options = config_methods.reject do |option|
      option.to_s.end_with? '='
    end
    before_values = config_options.map do |option|
      [option, Yarnlock.config.send(option)]
    end.to_h

    example.run

    before_values.each do |(option, value)|
      Yarnlock.config.send("#{option}=", value)
    end
  end
end
