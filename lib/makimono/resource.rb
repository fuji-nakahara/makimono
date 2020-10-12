# frozen_string_literal: true

module Makimono
  class Resource
    ORDERED_BASENAME_REGEXP = /\A(?<number>\d+)-(?<title>.+)\z/.freeze

    attr_reader :path
    attr_accessor :content

    def initialize(path, content)
      self.path = path
      @content = content
    end

    def path=(new_path)
      @path = Pathname.new(new_path).cleanpath.to_s
    end

    def dirname
      File.dirname(path)
    end

    def basename
      File.basename(path, '.*')
    end

    def basename=(new_basename)
      self.path = "#{dirname}/#{new_basename}#{extname}"
    end

    def extname
      File.extname(path)
    end

    def extname=(new_extname)
      self.path = "#{dirname}/#{basename}#{new_extname}"
    end

    def ordered?
      basename.match?(ORDERED_BASENAME_REGEXP)
    end

    def number
      basename[ORDERED_BASENAME_REGEXP, :number]&.to_i
    end

    def title
      basename[ORDERED_BASENAME_REGEXP, :title]
    end
  end
end
