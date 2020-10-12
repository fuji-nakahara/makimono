# frozen_string_literal: true

require 'thor'

require_relative '../makimono'
require_relative 'command/build'
require_relative 'command/new'

module Makimono
  class CLI < Thor
    def self.exit_on_failure?
      true
    end

    option :config, aliases: :c, banner: 'FILE', default: 'makimono.yml'
    register Command::Build, 'build', 'build', 'Build an ebook'

    register Command::New, 'new', 'new NAME', 'Create a new Makimono project'
  end
end
