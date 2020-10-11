# frozen_string_literal: true

module FixtureHelper
  def fixture_path(relative_path = '')
    File.expand_path(File.join('../fixtures', relative_path), __dir__)
  end
end
