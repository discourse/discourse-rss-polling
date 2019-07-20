# frozen_string_literal: true

module WellfedSpecHelper
  FILE_FIXTURE_PATH = File.join(
    ::Rails.root,
    'plugins',
    'discourse-wellfed',
    'spec',
    'fixtures',
    'files'
  )

  def wellfed_file_fixture(fixture_name)
    Pathname.new(File.join(FILE_FIXTURE_PATH, fixture_name))
  end
end

RSpec.configure do |config|
  config.include WellfedSpecHelper
end
