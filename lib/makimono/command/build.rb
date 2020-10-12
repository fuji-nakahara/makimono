# frozen_string_literal: true

require 'date'
require 'yaml'

module Makimono
  module Command
    class Build < Thor::Group
      class_option :config, aliases: :c, default: 'makimono.yml'

      def load_user_config
        user_config = if File.file?(options[:config])
                        yaml = File.read(options[:config])
                        filename = File.basename(options[:config])
                        YAML.safe_load(yaml, permitted_classes: [Date, Time], filename: filename, symbolize_names: true)
                      else
                        {}
                      end
        @config = Configuration.new(user_config)
      end

      def load_user_library
        Dir[File.join(@config[:library], '**/*.rb')].sort.each { |f| require f } if Dir.exist?(@config[:library])
      end

      def process
        Makimono::Processor.new(@config).process
      end
    end
  end
end
