# frozen_string_literal: true

require 'commonmarker'
require 'erb'
require 'gepub'
require 'pathname'
require 'yaml'

require_relative 'makimono/version'

module Makimono
  class Error < StandardError; end

  def self.build(source)
    config = YAML.load_file(File.expand_path('makimono.yml', source))
    docs_dir = File.expand_path('docs', source)

    book = GEPUB::Book.new

    book.identifier = config['identifier']
    book.language = config['language']
    book.title = config['title']

    book.ordered do
      Dir[File.join(docs_dir, '**/*.md')].sort.each do |doc_path|
        body = CommonMarker.render_html(File.read(doc_path))
        html = ERB.new(File.read(File.expand_path('template/doc.html.erb', __dir__))).result_with_hash(
          lang: config['language'],
          title: config['title'],
          body: body
        )
        relative_path = Pathname.new(doc_path).relative_path_from(docs_dir)
        book.add_item("#{File.basename(relative_path, '.md')}.html").add_raw_content(html)
      end
    end

    book.generate_epub(File.expand_path("output/#{config['title']}.epub", source))
  end
end
