# frozen_string_literal: true

require 'rails_helper'
require 'rss'

RSpec.describe DiscourseRssPolling::FeedItem do
  RSpec.shared_examples 'correctly parses the feed' do |**expected|
    let(:feed_item) { DiscourseRssPolling::FeedItem.new(raw_feed_item) }

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

  context 'ATOM item with content element' do
    let(:feed) { RSS::Parser.parse(file_from_fixtures('feed.atom', 'feed')) }
    let(:raw_feed_item) { feed.entries.first }

    include_examples(
      'correctly parses the feed',
      content: '<p>This is the body &amp; content. </p>',
      url: 'https://blog.discourse.org/2017/09/poll-feed-spec-fixture/',
      title: 'Poll Feed Spec Fixture',
    )
  end

  context 'ATOM item with summary element' do
    let(:raw_feed) { rss_polling_file_fixture('no_content_only_summary.atom').read }
    let(:feed) { RSS::Parser.parse(raw_feed) }
    let(:raw_feed_item) { feed.entries.first }

    include_examples(
      'correctly parses the feed',
      content: 'Here are some random descriptions...',
      url: 'https://blog.discourse.org/2017/09/poll-feed-spec-fixture/',
      title: 'Poll Feed Spec Fixture',
    )
  end
end
