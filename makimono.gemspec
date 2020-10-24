# frozen_string_literal: true

require_relative 'lib/makimono/version'

Gem::Specification.new do |spec|
  spec.name          = 'makimono'
  spec.version       = Makimono::VERSION
  spec.authors       = ['Fuji Nakahara']
  spec.email         = ['fujinakahara2032@gmail.com']

  spec.summary       = 'Provide a command line tool to generate an ebook from a set of markdown files'
  spec.homepage      = 'https://github.com/fuji-nakahara/makimono'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.6.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/fuji-nakahara/makimono'
  spec.metadata['changelog_uri'] = 'https://github.com/fuji-nakahara/makimono/blob/master/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'commonmarker', '>= 0.21'
  spec.add_dependency 'fuji_markdown', '>= 0.3'
  spec.add_dependency 'gepub', '>= 1.0'
  spec.add_dependency 'thor', '>= 1.0'
end
