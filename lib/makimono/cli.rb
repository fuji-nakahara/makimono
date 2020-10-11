# frozen_string_literal: true

require 'thor'
require 'yaml'

require_relative '../makimono'

module Makimono
  class CLI < Thor
    desc 'build', 'Build an EBook.'
    option :config, aliases: :c, banner: 'FILE', default: 'makimono.yml'
    def build
      overwrites = if File.exist?(options[:config])
                     yaml = File.read(options[:config])
                     YAML.safe_load(yaml, filename: options[:config], symbolize_names: true)
                   end
      config = Configuration.new(overwrites || {})
      Makimono::Processor.new(config).process
    end
  end
end
