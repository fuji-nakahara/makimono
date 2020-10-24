# frozen_string_literal: true

require 'gepub'
require 'time'

module Makimono
  class Generator
    class Epub
      def initialize(config, book: GEPUB::Book.new)
        @config = config
        @book = book
      end

      def generate(resources)
        add_required_metadata
        add_optional_metadata
        @book.page_progression_direction = @config[:page_progression_direction] if @config[:page_progression_direction]

        add_items([@config.style, *resources.reject(&:ordered?)].compact)
        add_ordered_items(resources.select(&:ordered?).sort_by(&:number))

        FileUtils.mkdir_p(@config[:output]) unless Dir.exist?(@config[:output])
        @book.generate_epub("#{File.expand_path(@config[:ebook_file_name], @config[:output])}.epub")
      end

      private

      def add_required_metadata
        @book.identifier = @config.fetch(:identifier)
        @book.lastmodified = @config.fetch(:modified)
        @book.title = @config.fetch(:title)
        @book.language = @config.fetch(:language)
      rescue KeyError => e
        raise InvalidConfigurationError, "Required metadata not found: #{e.key}"
      end

      def add_optional_metadata
        Array(@config[:creator]).each do |creator|
          @book.add_creator(creator)
        end
        Array(@config[:contributor]).each do |contributor|
          @book.add_contributor(contributor)
        end

        @book.add_date(@config[:date].to_time.iso8601) if @config[:date]
      end

      def add_items(resources)
        resources.each do |resource|
          @book.add_item(resource.path)
               .add_raw_content(resource.content)
        end
      end

      def add_ordered_items(resources)
        @book.ordered do
          resources.each do |resource|
            @book.add_item(resource.path)
                 .add_raw_content(resource.content)
                 .toc_text(resource.title)
          end
        end
      end
    end
  end
end
