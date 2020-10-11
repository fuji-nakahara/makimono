# frozen_string_literal: true

module Makimono
  class Converter
    autoload :Markdown, 'makimono/converter/markdown'

    def self.from_config(config)
      klasses = if config[:converters] == ['Markdown']
                  [Markdown]
                else
                  config[:converters].map do |name|
                    const_get(name.to_s)
                  rescue NameError
                    raise InvalidConverterError, "Invalid converter configuration: #{name}"
                  end
                end
      new(klasses.map { |klass| klass.new(config) })
    end

    attr_reader :converters

    def initialize(converters)
      @converters = converters
    end

    def convert(resource)
      converters.inject(resource) do |res, converter|
        if converter.convertible?(res)
          converter.convert(res)
        else
          res
        end
      end
    end
  end
end
