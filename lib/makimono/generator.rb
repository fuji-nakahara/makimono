# frozen_string_literal: true

module Makimono
  class Generator
    autoload :Epub, 'makimono/generator/epub'
    autoload :SimpleFile, 'makimono/generator/simple_file'

    def self.from_config(config)
      klass = if config[:generator].upcase == 'EPUB'
                Epub
              elsif config[:generator] == 'SimpleFile'
                SimpleFile
              else
                const_get(config[:generator].to_s)
              end
      new(klass.new(config))
    rescue NameError
      raise InvalidGeneratorError, "Invalid generator configuration: #{config[:generator]}"
    end

    attr_reader :generator

    def initialize(generator)
      @generator = generator
    end

    def generate(documents)
      generator.generate(documents)
    end
  end
end
