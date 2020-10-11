# frozen_string_literal: true

require 'commonmarker'

module Makimono
  class Converter
    class Markdown
      class CommonMarker
        def initialize(config)
          @config = config
        end

        def render(markdown)
          ::CommonMarker.render_html(markdown, options, extensions)
        end

        private

        def options
          @config.dig(:CommonMarker, :options)&.map(&:upcase)&.map(&:to_sym) || :DEFAULT
        end

        def extensions
          @config.dig(:CommonMarker, :extensions)&.map(&:downcase)&.map(&:to_sym) || []
        end
      end
    end
  end
end
