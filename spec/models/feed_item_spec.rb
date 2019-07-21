# frozen_string_literal: true

require 'rails_helper'
require 'rss'

RSpec.describe DiscourseWellfed::FeedItem do
  RSpec.shared_examples 'correctly parses the feed' do |**expected|
    let(:feed_item) { DiscourseWellfed::FeedItem.new(raw_feed_item) }

    it { expect(feed_item.content).to eq(expected[:content]) }
    it { expect(feed_item.url).to eq(expected[:url]) }
    it { expect(feed_item.title).to eq(expected[:title]) }
  end

  context 'Empty item' do
    let(:raw_feed_item) { {} }
    include_examples(
      'correctly parses the feed',
      content: nil,
      url: nil,
      title: nil,
    )
  end

  context 'RSS item' do
    let(:feed) { RSS::Parser.parse(file_from_fixtures('feed.rss', 'feed')) }
    let(:raw_feed_item) { feed.items.first }
    include_examples(
      'correctly parses the feed',
      content: '<p>This is the body &amp; content. </p>',
      url: 'https://blog.discourse.org/2017/09/poll-feed-spec-fixture/',
      title: 'Poll Feed Spec Fixture',
    )
  end

  context 'ATOM item' do
    let(:feed) { RSS::Parser.parse(file_from_fixtures('feed.atom', 'feed')) }
    let(:raw_feed_item) { feed.entries.first }
    include_examples(
      'correctly parses the feed',
      content: '<p>This is the body &amp; content. </p>',
      url: 'https://blog.discourse.org/2017/09/poll-feed-spec-fixture/',
      title: 'Poll Feed Spec Fixture',
    )
  end

  context 'ATOM item with media extension' do
    let(:feed) { RSS::Parser.parse(wellfed_file_fixture('media-rss.atom')) }
    let(:raw_feed_item) { feed.entries.first }

    include_examples(
      'correctly parses the feed',
      content: 'I can parse Media RSS!',
      url: 'https://www.youtube.com/watch?v=54321',
      title: 'Media RSS Extension',
    )
  end
end
