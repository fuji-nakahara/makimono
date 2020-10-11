# frozen_string_literal: true

require 'fuji_markdown'

module Makimono
  class Converter
    class Markdown
      class FujiMarkdown
        def initialize(config)
          @config = config
        end

        def render(markdown)
          ::FujiMarkdown.render(markdown, option)
        end

        private

        def option
          @config[:FujiMarkdown]&.upcase&.to_sym || :HTML
        end
      end
    end
  end
end
