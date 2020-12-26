# frozen_string_literal: true

require 'fileutils'

module Makimono
  class Generator
    class SimpleFile
      def initialize(config)
        @config = config
      end

      def generate(resources)
        FileUtils.mkdir_p(@config[:output]) unless Dir.exist?(@config[:output])

        resources.each do |resource|
          output_path = File.expand_path(resource.path, @config[:output])
          File.write(output_path, resource.content)
        end
      end
    end
  end
end
