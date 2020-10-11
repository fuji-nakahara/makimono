# frozen_string_literal: true

RSpec.describe Makimono::Converter::Markdown do
  describe '.get_markdown_class' do
    subject(:get_markdown_class) { described_class.get_markdown_class(class_name) }

    context 'with CommonMarker' do
      let(:class_name) { 'CommonMarker' }

      it { is_expected.to eq described_class::CommonMarker }
    end

    context 'with FujiMarkdown' do
      let(:class_name) { 'FujiMarkdown' }

      it { is_expected.to eq described_class::FujiMarkdown }
    end

    context 'with custom markdown' do
      let(:class_name) { 'CustomMarkdown' }
      let(:markdown) { Class.new }

      before do
        described_class.const_set(class_name, markdown)
      end

      after do
        described_class.send(:remove_const, class_name)
      end

      it { is_expected.to eq markdown }
    end

    context 'with invalid markdown' do
      let(:class_name) { 'Invalid' }

      it 'raises InvalidMarkdownError' do
        expect { get_markdown_class }.to raise_error Makimono::InvalidMarkdownError
      end
    end
  end

  describe '.get_template_path' do
    subject(:get_template_path) { described_class.get_template_path(template_config) }

    context 'with a preset' do
      let(:template_config) { 'default.xhtml' }

      it { is_expected.to end_with 'templates/default.xhtml.erb' }
    end

    context 'with a custom template' do
      let(:template_config) { fixture_path('template.html.erb') }

      it { is_expected.to end_with 'template.html.erb' }
    end

    context 'with an invalid template' do
      let(:template_config) { 'invalid' }

      it 'raises InvalidTemplateError' do
        expect { get_template_path }.to raise_error Makimono::InvalidTemplateError
      end
    end
  end

  describe '#convert' do
    let(:markdown) { double(:markdown, render: '<h1>Test</h1>') }
    let(:resource) { Makimono::Resource.new('Chapter1/01-Prologue.md', content: '# Test') }

    context 'with default config' do
      let(:config) { Makimono::Configuration.new }

      it 'returns XHTML resource' do
        converted = described_class.new(config, markdown: markdown).convert(resource)

        expect(converted.extname).to eq '.xhtml'
        expect(converted.content).to eq <<~HTML
          <?xml version="1.0" encoding="UTF-8"?>
          <!DOCTYPE html>
          <html xmlns="http://www.w3.org/1999/xhtml" xmlns:epub="http://www.idpf.org/2007/ops" xml:lang="ja" lang="ja">
            <head>
              <meta charset="utf-8" />
              <title>Prologue</title>
              
            </head>
            <body epub:type="bodymatter">
              <h1>Test</h1>
            </body>
          </html>
        HTML
      end
    end

    context 'with style config' do
      let(:config) { Makimono::Configuration.new({ style: 'fuji' }) }

      it 'returns XHTML resource with style' do
        converted = described_class.new(config, markdown: markdown).convert(resource)

        expect(converted.content).to eq <<~HTML
          <?xml version="1.0" encoding="UTF-8"?>
          <!DOCTYPE html>
          <html xmlns="http://www.w3.org/1999/xhtml" xmlns:epub="http://www.idpf.org/2007/ops" xml:lang="ja" lang="ja">
            <head>
              <meta charset="utf-8" />
              <title>Prologue</title>
              
                <link rel="stylesheet" type="text/css" href="../fuji.css" />
              
            </head>
            <body epub:type="bodymatter">
              <h1>Test</h1>
            </body>
          </html>
        HTML
      end
    end

    context 'with template config `empty.txt`' do
      let(:config) { { template: 'empty.txt' } }

      it 'returns text resource' do
        converted = described_class.new(config, markdown: markdown).convert(resource)

        expect(converted.extname).to eq '.txt'
        expect(converted.content).to eq "<h1>Test</h1>\n"
      end
    end
  end
end
