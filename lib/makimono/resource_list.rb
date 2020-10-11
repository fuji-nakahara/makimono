# frozen_string_literal: true

require_relative 'resource'

module Makimono
  class ResourceList
    include Enumerable

    def self.from_dir(dir)
      raise InvalidSourceError, "Source directory `#{dir}` does not exist" unless Dir.exist?(dir)

      resources = []
      Dir.chdir(dir) do
        Dir['**/*'].each do |path|
          content = File.read(path)
          resources << Resource.new(path, content)
        end
      end
      new(resources)
    end

    def initialize(resources)
      @resources = resources
    end

    def each(&block)
      @resources.each(&block)
    end

    def ordered
      @resources.select(&:ordered?).sort_by(&:number)
    end

    def not_ordered
      @resources.reject(&:ordered?)
    end
  end
end
