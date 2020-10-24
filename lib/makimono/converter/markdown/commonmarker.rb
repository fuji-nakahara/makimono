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
          if (options = @config.dig(:CommonMarker, :options))
            Array(options).map(&:upcase).map(&:to_sym)
          else
            :DEFAULT
          end
        end

        def extensions
          @config.dig(:CommonMarker, :extensions)&.map(&:downcase)&.map(&:to_sym) || []
        end
      end
    end
  end
end
