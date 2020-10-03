# frozen_string_literal: true

RSpec.describe Makimono do
  describe '.build' do
    let(:source) { File.expand_path('fixtures/japanese-novel', __dir__) }

    it 'generates an EBook' do
      described_class.build(source)

      path = File.join(source, 'output/日本語小説のサンプル.epub')
      expect(File).to exist(path)
      File.delete(path)
    end
  end
end
