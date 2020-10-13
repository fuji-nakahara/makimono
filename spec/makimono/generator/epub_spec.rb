# frozen_string_literal: true

RSpec.describe Makimono::Generator::Epub do
  describe '#generate' do
    let(:config) { Makimono::Configuration.new }
    let(:book_spy) { spy(:book) }
    let(:resources) { [] }

    before do
      allow(book_spy).to receive(:ordered).and_yield
    end

    it 'calls #generate_epub' do
      described_class.new(config, book: book_spy).generate(resources)

      expect(book_spy).to have_received(:identifier=).with(/\Aurn:uuid:/)
      expect(book_spy).to have_received(:title=).with('No title')
      expect(book_spy).to have_received(:language=).with('ja')
      expect(book_spy).to have_received(:generate_epub).with(%r{out/book\.epub\z})
    end

    context 'with creator config' do
      let(:config) { Makimono::Configuration.new({ creator: 'Creator' }) }

      it 'calls #add_creator' do
        described_class.new(config, book: book_spy).generate(resources)

        expect(book_spy).to have_received(:add_creator).with('Creator')
      end
    end

    context 'with date config' do
      let(:config) { Makimono::Configuration.new({ date: Date.parse('2020-10-01') }) }

      it 'calls #add_date' do
        described_class.new(config, book: book_spy).generate(resources)

        expect(book_spy).to have_received(:add_date).with(/\A2020-10-01T00:00:00/)
      end
    end

    context 'with page_progression_direction config' do
      let(:config) { Makimono::Configuration.new({ page_progression_direction: 'rtl' }) }

      it 'calls #page_progression_direction=' do
        described_class.new(config, book: book_spy).generate(resources)

        expect(book_spy).to have_received(:page_progression_direction=).with('rtl')
      end
    end

    context 'with a not ordered resource' do
      let(:resources) { [resource] }
      let(:resource) { Makimono::Resource.new('image.png', 'dummy image') }
      let(:item_spy) { instance_spy(GEPUB::Item) }

      before do
        allow(book_spy).to receive(:add_item).with(resource.path).and_return(item_spy)
      end

      it 'calls #add_item' do
        described_class.new(config, book: book_spy).generate(resources)

        expect(item_spy).to have_received(:add_raw_content).with(resource.content)
      end
    end

    context 'with an ordered resource' do
      let(:resources) { [resource] }
      let(:resource) { Makimono::Resource.new('01-body.xhtml', 'dummy content') }
      let(:item_spy) { instance_spy(GEPUB::Item) }

      before do
        allow(book_spy).to receive(:add_item).with(resource.path).and_return(item_spy)
        allow(item_spy).to receive(:add_raw_content).and_return(item_spy)
      end

      it 'calls #add_item' do
        described_class.new(config, book: book_spy).generate(resources)

        expect(item_spy).to have_received(:add_raw_content).with(resource.content)
        expect(item_spy).to have_received(:toc_text).with('body')
      end
    end
  end
end
