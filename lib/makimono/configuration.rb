# frozen_string_literal: true

require 'forwardable'
require 'securerandom'

require_relative 'style'

module Makimono
  class Configuration
    extend Forwardable

    DEFAULTS = {
      # Makimono
      source: 'src',
      output: 'out',
      library: 'lib',
      converters: %w[Markdown],
      markdown: 'CommonMarker',
      CommonMarker: {
        options: 'DEFAULT',
        extensions: []
      },
      template: 'default.xhtml',
      style: nil,
      generator: 'EPUB',
      ebook_file_name: 'book',

      # EPUB
      identifier: "urn:uuid:#{SecureRandom.uuid}",
      modified: Time.now,
      title: 'No title',
      language: 'ja',
      creator: nil,
      contributor: nil,
      date: nil,
      page_progression_direction: nil
    }.freeze

    def_delegators :@config, :[], :fetch, :dig

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
