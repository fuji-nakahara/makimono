# frozen_string_literal: true

require 'thor'

module Makimono
  module Command
    class New < Thor::Group
      include Thor::Actions

      argument :name, required: true

      def self.source_root
        File.expand_path('../../project_template', __dir__)
      end

      def set_destination_root
        self.destination_root = name
      end

      def create_files
        copy_file('.gitignore')
        copy_file('Gemfile')
        template('makimono.yml', { name: name })
        copy_file('src/01-Title.md', "src/01-#{name.capitalize}.md")
      end

      def run_bundle_install
        in_root do
          run('bundle install')
        end
      end
    end
  end
end
