# frozen_string_literal: true

RSpec.describe Makimono::Processor do
  describe '#process' do
    let(:converter) { instance_spy(Makimono::Converter) }
    let(:generator) { instance_spy(Makimono::Generator) }
    let(:resources) { [instance_double(Makimono::Resource), instance_double(Makimono::Resource)] }

    before do
      resources.each do |resource|
        allow(converter).to receive(:convert).with(resource).and_return(resource)
      end
    end

    it 'calls Converter#convert! and Generator#generate with resources' do
      described_class.new({}, converter: converter, generator: generator).process(resources)

      expect(converter).to have_received(:convert).with(resources[0])
      expect(converter).to have_received(:convert).with(resources[1])
      expect(generator).to have_received(:generate).with(resources)
    end
  end
end
