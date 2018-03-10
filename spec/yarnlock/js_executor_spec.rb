# frozen_string_literal: true

RSpec.describe Yarnlock::JsExecutor do
  describe '.script_path' do
    before { Yarnlock.config.script_dir = '/path/to/scripts' }

    subject { Yarnlock::JsExecutor.script_path('script_name') }

    it { is_expected.to eq 'node /path/to/scripts/script_name' }
  end
end
