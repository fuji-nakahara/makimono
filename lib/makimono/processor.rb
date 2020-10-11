# frozen_string_literal: true

require_relative 'converter'
require_relative 'generator'
require_relative 'resource_list'

module Makimono
  class Processor
    def initialize(config, converter: Converter.from_config(config), generator: Generator.from_config(config))
      @config = config
      @converter = converter
      @generator = generator
    end

    def process(resources = ResourceList.from_dir(@config[:source]))
      converted_resources = resources.map do |resource|
        @converter.convert(resource)
      end
      @generator.generate(converted_resources)
    end
  end
end
