# frozen_string_literal: true

RSpec.describe Makimono::Converter::Markdown::FujiMarkdown do
  describe '#render' do
    let(:config) { Makimono::Configuration.new }
    let(:markdown) { '# test' }

    let!(:fuji_markdown) { class_spy(FujiMarkdown).as_stubbed_const }

    it 'calls FujiMarkdown.render' do
      described_class.new(config).render(markdown)

      expect(fuji_markdown).to have_received(:render).with(markdown, :HTML)
    end

    context 'with CommonMarker config' do
      let(:config) { Makimono::Configuration.new({ FujiMarkdown: 'kakuyomu' }) }

      it 'calls CommonMarker.render_html with args' do
        described_class.new(config).render(markdown)

        expect(fuji_markdown).to have_received(:render).with(markdown, :KAKUYOMU)
      end
    end
  end
end
