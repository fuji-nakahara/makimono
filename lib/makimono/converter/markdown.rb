# frozen_string_literal: true

require 'erb'

module Makimono
  class Converter
    class Markdown
      autoload :CommonMarker, 'makimono/converter/markdown/commonmarker'
      autoload :FujiMarkdown, 'makimono/converter/markdown/fuji_markdown'

      PRESETS = %w[default.xhtml empty.txt].freeze

      def self.get_markdown_class(class_name)
        case class_name
        when 'CommonMarker'
          CommonMarker
        when 'FujiMarkdown'
          FujiMarkdown
        else
          const_get(class_name.to_s)
        end
      rescue NameError
        raise InvalidMarkdownError, "Invalid markdown configuration: #{class_name}"
      end

      def self.get_template_path(template_config)
        if PRESETS.include?(template_config)
          File.expand_path("../../templates/#{template_config}.erb", __dir__)
        elsif File.exist?(template_config.to_s)
          File.expand_path(template_config.to_s)
        else
          raise InvalidTemplateError, "Template file `#{template_config}` does not exist"
        end
      end

      def initialize(config, markdown: nil)
        @config = config
        @markdown = markdown || self.class.get_markdown_class(config[:markdown]).new(config)
        @template_path = self.class.get_template_path(config[:template])
      end

      def convertible?(resource)
        %w[.markdown .mkdown .mkdn .mkd .md].include?(resource.extname)
      end

      def convert(resource)
        converted = resource.dup
        converted.content = convert_content(resource)
        converted.extname = File.extname(File.basename(@template_path, '.erb'))
        converted
      end

      private

      def convert_content(resource)
        body = @markdown.render(resource.content)
        ERB.new(template).result_with_hash(
          {
            config: @config,
            resource: resource,
            body: body
          }
        )
      end

      def template
        @template ||= File.read(@template_path)
      end
    end
  end
end
