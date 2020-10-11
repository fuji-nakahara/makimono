# frozen_string_literal: true

RSpec.describe Makimono::Style do
  describe '.from_style_config' do
    context 'with a preset' do
      let(:style_config) { 'fuji' }

      it 'returns Style instance with the preset path' do
        style = described_class.from_style_config(style_config)

        expect(style).to be_a described_class
        expect(style.path).to eq 'fuji.css'
      end
    end

    context 'with a custom style' do
      let(:style_config) { fixture_path('style.css') }

      it 'returns Style instance with custom style path' do
        style = described_class.from_style_config(style_config)

        expect(style).to be_a described_class
        expect(style.path).to eq 'style.css'
      end
    end

    context 'with an invalid style' do
      let(:style_config) { 'invalid.css' }

      it 'raises InvalidStyleError' do
        expect { described_class.from_style_config(style_config) }.to raise_error Makimono::InvalidStyleError
      end
    end
  end
end
