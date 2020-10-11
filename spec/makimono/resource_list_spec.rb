# frozen_string_literal: true

RSpec.describe Makimono::ResourceList do
  describe '.from_dir' do
    let(:dir) { fixture_path('src') }

    it 'loads files and returns instance' do
      resources = described_class.from_dir(dir)

      expect(resources).to be_a described_class
      expect(resources.map(&:basename)).to match_array %w[01-Prologue 99-Epilogue]
    end

    context 'with invalid dir' do
      let(:dir) { 'invalid' }

      it 'raises InvalidSourceError' do
        expect { described_class.from_dir(dir) }.to raise_error Makimono::InvalidSourceError
      end
    end
  end
end
