# frozen_string_literal: true

module Makimono
  Error = Class.new(StandardError)
  InvalidConfigurationError = Class.new(Error)
  InvalidSourceError = Class.new(InvalidConfigurationError)
  InvalidConverterError = Class.new(InvalidConfigurationError)
  InvalidGeneratorError = Class.new(InvalidConfigurationError)
  InvalidMarkdownError = Class.new(InvalidConfigurationError)
  InvalidTemplateError = Class.new(InvalidConfigurationError)
  InvalidStyleError = Class.new(InvalidConfigurationError)
end
