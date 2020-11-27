# frozen_string_literal: true

RSpec.describe Yarnlock::Entry do
  let(:pattern) { 'string-width@^2.1.0, string-width@^2.1.1' }
  let(:pattern_yarnlock) { '@yarnpkg/lockfile@^1.0.0' }
  let(:entry) do
    {
      'version' => '2.1.1',
      'resolved' => 'https://registry.yarnpkg.com/string-width/-/string-width-2.1.1.tgz#ab93f27a8dc13d28cac815c462143a6d9012ae9e',
      'dependencies' => {
        'is-fullwidth-code-point' => '^2.0.0',
        'strip-ansi' => '^4.0.0'
      }
    }
  end

  describe '.parse' do
    subject { Yarnlock::Entry.parse pattern, entry }

    context 'when multiple version ranges specified' do
      it { expect(subject.package).to eq 'string-width' }
      it { expect(subject.version_ranges).to eq %w[^2.1.0 ^2.1.1] }
    end

    context 'when scoped package' do
      let(:pattern) { pattern_yarnlock }

      it { expect(subject.package).to eq '@yarnpkg/lockfile' }
      it { expect(subject.version_ranges).to eq %w[^1.0.0] }
    end
  end

  describe '#to_h' do
    subject { Yarnlock::Entry.parse(pattern, entry).to_h }

    it { is_expected.to eq pattern => entry }

    context 'when empty attribute in entry' do
      before { entry.delete 'dependencies' }

      it { is_expected.to eq pattern => entry }
    end
  end

  let(:other) do
    Yarnlock::Entry.new(
      package: 'string-width',
      version_ranges: %w[^2.1.0 ^2.1.1],
      version: '2.1.1',
      resolved: 'https://registry.yarnpkg.com/string-width/-/string-width-2.1.1.tgz#ab93f27a8dc13d28cac815c462143a6d9012ae9e',
      dependencies: {
        'is-fullwidth-code-point' => '^2.0.0',
        'strip-ansi' => '^4.0.0'
      }
    )
  end

  describe '#==' do
    subject { Yarnlock::Entry.parse(pattern, entry) == other }

    it { is_expected.to be_truthy }

    context 'when an attribute differs' do
      before { other.package = '@yarnpkg/lockfile' }

      it { is_expected.to be_falsey }
    end
  end

  describe '#eql?' do
    subject { Yarnlock::Entry.parse(pattern, entry).eql? other }

    it { is_expected.to be_truthy }

    context 'when an attribute differs' do
      before { other.package = '@yarnpkg/lockfile' }

      it { is_expected.to be_falsey }
    end
  end

  describe '#hash' do
    subject { Yarnlock::Entry.parse(pattern, entry).hash }

    it { is_expected.to be other.hash }

    context 'when an attribute differs' do
      before { other.package = '@yarnpkg/lockfile' }

      it { is_expected.not_to be other.hash }
    end
  end
end
