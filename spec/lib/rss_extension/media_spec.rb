# frozen_string_literal: true

require 'rails_helper'
require 'rss_extension/media'

WELLFED_FILE_FIXTURE_PATH = "#{Rails.root}/plugins/discourse-wellfed/spec/fixtures/files/"

def wellfed_file_fixture(fixture_name)
  Pathname.new(File.join(WELLFED_FILE_FIXTURE_PATH, fixture_name))
end

RSpec.describe RSSExtension::Media do
  it 'parses Atom feed with Media RSS extension' do
    raw_feed = wellfed_file_fixture('media-rss.atom').read
    feed = RSS::Parser.parse(raw_feed)
    entry = feed.entries.first

    expect(entry.media_group.media_title).to eq('Media RSS Extension')
    expect(entry.media_group.media_description).to eq('I can parse Media RSS!')
  end
end
