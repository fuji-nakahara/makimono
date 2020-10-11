# frozen_string_literal: true

RSpec.describe 'makimono', type: :aruba do # rubocop:disable RSpec/DescribeClass
  describe 'build' do
    context 'with fixtures' do
      before do
        File.delete(fixture_path('out/fixture.epub')) if File.exist?(fixture_path('out/fixture.epub'))
      end

      it 'generates out/fixture.epub' do
        cd fixture_path do
          run_command 'makimono build'
        end

        expect(last_command_started).to be_successfully_executed
        expect(File).to exist fixture_path('out/fixture.epub')
      end
    end

    context 'with --config option' do
      before do
        FileUtils.rm_rf(fixture_path('out/kakuyomu')) if Dir.exist?(fixture_path('out/kakuyomu'))
      end

      it 'generates text files' do
        cd fixture_path do
          run_command 'makimono build --config kakuyomu.yml'
        end

        expect(last_command_started).to be_successfully_executed
        expect(File).to exist fixture_path('out/kakuyomu/01-Prologue.txt')
        expect(File).to exist fixture_path('out/kakuyomu/99-Epilogue.txt')
      end
    end
  end
end
