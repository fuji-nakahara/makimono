# frozen_string_literal: true

require_relative 'resource'

module Makimono
  class Style < Resource
    PRESETS = %w[fuji fuji_tategaki].freeze

    def self.from_style_config(style_config)
      path = if PRESETS.include?(style_config)
               File.expand_path("../styles/#{style_config}.css", __dir__)
             elsif File.exist?(style_config.to_s)
               File.expand_path(style_config.to_s)
             else
               raise InvalidStyleError, "Style file `#{style_config}` does not exist"
             end

      new(File.basename(path), File.read(path))
    end

    def relative_path_from(dir)
      Pathname.new(path).relative_path_from(dir)
    end
  end
end
