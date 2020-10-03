# frozen_string_literal: true

require 'thor'

require_relative '../makimono'

module Makimono
  class CLI < Thor
    desc 'build', 'Build an EBook.'
    def build
      Makimono.build(Dir.pwd)
    end
  end
end
