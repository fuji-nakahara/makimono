# frozen_string_literal: true

RSpec.describe Makimono::Generator do
  describe '.from_config' do
    context 'with the default config' do
      let(:config) { Makimono::Configuration.new }

      it 'uses Ebook generator' do
        generator = described_class.from_config(config)

        expect(generator).to be_a described_class
        expect(generator.generator).to be_a described_class::Epub
      end
    end

    context 'with custom generator config' do
      let(:config) { { generator: generator_name } }
      let(:generator_name) { 'CustomGenerator' }
      let(:generator_class) do
        Class.new do
          def initialize(_config) end
        end
      end

      before do
        described_class.const_set(generator_name, generator_class)
      end

      after do
        described_class.send(:remove_const, generator_name)
      end

      it 'uses the custom generator' do
        generator = described_class.from_config(config)

        expect(generator).to be_a described_class
        expect(generator.generator).to be_a generator_class
      end
    end

    context 'with invalid generator config' do
      let(:config) { { generator: %w[Invalid] } }

      it 'raises InvalidGeneratorError' do
        expect { described_class.from_config(config) }.to raise_error Makimono::InvalidGeneratorError
      end
    end
  end
end
