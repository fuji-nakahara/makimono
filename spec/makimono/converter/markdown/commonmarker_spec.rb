# frozen_string_literal: true

RSpec.describe Makimono::Converter::Markdown::CommonMarker do # rubocop:disable RSpec/FilePath
  describe '#render' do
    let(:config) { Makimono::Configuration.new }
    let(:markdown) { '# test' }

    let!(:commonmarker) { class_spy(CommonMarker).as_stubbed_const }

    it 'calls CommonMarker.render_html' do
      described_class.new(config).render(markdown)

      expect(commonmarker).to have_received(:render_html).with(markdown, :DEFAULT, [])
    end

    context 'with CommonMarker config' do
      let(:config) do
        Makimono::Configuration.new(
          {
            CommonMarker: {
              options: %w[HARDBREAKS],
              extensions: %w[table]
            }
          }
        )
      end

      it 'calls CommonMarker.render_html with args' do
        described_class.new(config).render(markdown)

        expect(commonmarker).to have_received(:render_html).with(markdown, %i[HARDBREAKS], %i[table])
      end
    end
  end
end
