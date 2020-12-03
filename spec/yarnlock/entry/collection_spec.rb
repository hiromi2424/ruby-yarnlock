# frozen_string_literal: true

require 'semantic/core_ext'

RSpec.describe Yarnlock::Entry::Collection do
  let(:pattern1) { 'resolve@1.1.7' }
  let(:pattern2) { 'resolve@^1.1.6, resolve@^1.1.7' }
  let(:entry1) do
    {
      'version' => '1.1.7',
      'resolved' => 'https://registry.yarnpkg.com/resolve/-/resolve-1.1.7.tgz#203114d82ad2c5ed9e8e0411b3932875e889e97b'
    }
  end
  let(:entry2) do
    {
      'version' => '1.3.3',
      'resolved' => 'https://registry.yarnpkg.com/resolve/-/resolve-1.3.3.tgz#655907c3469a8680dc2de3a275a8fdd69691f0e5'
    }
  end
  let(:raw_hash) { { pattern1 => entry1, pattern2 => entry2 } }
  let(:array_expression) do
    [
      Yarnlock::Entry.parse(pattern1, entry1),
      Yarnlock::Entry.parse(pattern2, entry2)
    ]
  end

  describe '.parse' do
    subject { Yarnlock::Entry::Collection.parse(raw_hash) }

    it { is_expected.to eq array_expression }
    it { is_expected.to be_a_kind_of Yarnlock::Entry::Collection }
  end

  let(:yarnlock_entry) do
    Yarnlock::Entry.parse('@yarnpkg/lockfile@^1.0.0',
                          'version' => '1.0.0',
                          'resolved' => 'https://registry.yarnpkg.com/@yarnpkg/lockfile/-/lockfile-1.0.0.tgz#33d1dbb659a23b81f87f048762b35a446172add3')
  end
  let(:collection) do
    (array_expression + [yarnlock_entry]).extend(Yarnlock::Entry::Collection)
  end

  describe '.package_with_versions' do
    subject { collection.package_with_versions }

    it 'returns 2 dimensional hash' do
      is_expected.to eq(
        'resolve' => {
          '1.1.7'.to_version => Yarnlock::Entry.parse(pattern1, entry1),
          '1.3.3'.to_version => Yarnlock::Entry.parse(pattern2, entry2)
        },
        '@yarnpkg/lockfile' => {
          '1.0.0'.to_version => yarnlock_entry
        }
      )
    end
  end

  describe '.highest_version_packages' do
    subject { collection.highest_version_packages }

    it 'returns highest packages as hash' do
      is_expected.to eq(
        'resolve' => Yarnlock::Entry.parse(pattern2, entry2),
        '@yarnpkg/lockfile' => yarnlock_entry
      )
    end
  end

  describe '.as_json' do
    subject { array_expression.extend(Yarnlock::Entry::Collection).as_json }

    it { is_expected.to eq raw_hash }
  end
end
