# frozen_string_literal: true

require 'forwardable'
require 'securerandom'

require_relative 'style'

module Makimono
  class Configuration
    extend Forwardable

    DEFAULTS = {
      # Makimono
      source: File.expand_path('src'),
      output: File.expand_path('out'),
      style: nil,
      template: 'default.xhtml',
      markdown: 'CommonMarker',
      converters: %w[Markdown],
      generator: 'EPUB',
      ebook_file_name: 'book',

      # EPUB
      identifier: "urn:uuid:#{SecureRandom.uuid}",
      title: 'No title',
      language: 'ja'
    }.freeze

    def_delegators :@config, :[], :fetch, :dig, :slice

    def initialize(config = {})
      @config = DEFAULTS.merge(config)
    end

    def to_h
      @config
    end

    def style
      return @style if defined? @style

      @style = if @config[:style].nil? || @config[:style].empty?
                 nil
               else
                 Style.from_style_config(@config[:style])
               end
    end
  end
end
