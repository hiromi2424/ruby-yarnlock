# frozen_string_literal: true

RSpec.describe Yarnlock::Entry::Collection do
  let(:pattern_1) { 'resolve@1.1.7' }
  let(:pattern_2) { 'resolve@^1.1.6, resolve@^1.1.7' }
  let(:entry_1) do
    {
      'version' => '1.1.7',
      'resolved' => 'https://registry.yarnpkg.com/resolve/-/resolve-1.1.7.tgz#203114d82ad2c5ed9e8e0411b3932875e889e97b'
    }
  end
  let(:entry_2) do
    {
      'version' => '1.3.3',
      'resolved' => 'https://registry.yarnpkg.com/resolve/-/resolve-1.3.3.tgz#655907c3469a8680dc2de3a275a8fdd69691f0e5'
    }
  end

  describe '.parse' do
    subject { Yarnlock::Entry::Collection.parse(pattern_1 => entry_1, pattern_2 => entry_2) }

    let(:expected) do
      Yarnlock::Entry::Collection.new.merge(
        'resolve' => {
          '1.1.7' => Yarnlock::Entry.parse(pattern_1, entry_1),
          '1.3.3' => Yarnlock::Entry.parse(pattern_2, entry_2)
        }
      )
    end

    it { is_expected.to eq expected }
  end
end
