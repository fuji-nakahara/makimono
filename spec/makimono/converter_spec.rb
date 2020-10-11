# frozen_string_literal: true

RSpec.describe Makimono::Converter do
  describe '.from_config' do
    context 'with the default config' do
      let(:config) { Makimono::Configuration.new }

      it 'uses Markdown converter' do
        converter = described_class.from_config(config)

        expect(converter).to be_a described_class
        expect(converter.converters).to match [instance_of(described_class::Markdown)]
      end
    end

    context 'with custom converter config' do
      let(:config) { { converters: [converter_name] } }
      let(:converter_name) { 'CustomConverter' }
      let(:converter_class) do
        Class.new do
          def initialize(_config) end
        end
      end

      before do
        described_class.const_set(converter_name, converter_class)
      end

      after do
        described_class.send(:remove_const, converter_name)
      end

      it 'uses the custom converter' do
        converter = described_class.from_config(config)

        expect(converter).to be_a described_class
        expect(converter.converters).to match [instance_of(converter_class)]
      end
    end

    context 'with invalid converter config' do
      let(:config) { { converters: %w[Invalid] } }

      it 'raises InvalidConverterError' do
        expect { described_class.from_config(config) }.to raise_error Makimono::InvalidConverterError
      end
    end
  end

  describe '#convert' do
    let(:converter1) { double(:converter, convertible?: true) }
    let(:converter2) { double(:converter, convertible?: false) }
    let(:resource) { Makimono::Resource.new('test.md', content: '# Test') }

    before do
      allow(converter1).to receive(:convert).with(resource).and_return(
        Makimono::Resource.new('test.html', '<h1>Test</h1>')
      )
    end

    it 'returns converted resource' do
      converted = described_class.new([converter1, converter2]).convert(resource)

      expect(converted.path).to eq 'test.html'
      expect(converted.content).to eq '<h1>Test</h1>'
    end
  end
end
