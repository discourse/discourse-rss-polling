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

  context 'escaped title' do
    let(:raw_feed) { rss_polling_file_fixture('escaped_html.atom').read }
    let(:feed) { RSS::Parser.parse(raw_feed) }
    let(:raw_feed_item) { feed.entries.first }

    include_examples(
      'correctly parses the feed',
      content: 'Here are some random descriptions...',
      url: 'https://blog.discourse.org/2017/09/poll-feed-spec-fixture/',
      title: 'Wellington: “Progress is hard!” Other cities: “Hold my beer”',
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

  context 'ATOM items with categories elements' do
    let(:raw_feed) { rss_polling_file_fixture('multiple_categories.atom').read }
    let(:feed) { RSS::Parser.parse(raw_feed, false) }
    let(:raw_feed_item) { feed.entries.first }

    include_examples(
      'correctly parses the feed',
      content: 'Here are some random descriptions...',
      url: 'https://blog.discourse.org/2017/09/poll-feed-spec-fixture/',
      title: 'Poll Feed Spec Fixture',
      categories: ['spec', 'xrav3nz diary']
    )
  end

  context 'Youtube playlist' do
    let(:raw_feed) { rss_polling_file_fixture('youtube_playlist.xml').read }
    let(:feed) { RSS::Parser.parse(raw_feed, false) }
    let(:raw_feed_item) { feed.entries.first }

    include_examples(
      'correctly parses the feed',
      content: "<div><iframe width=\"690\" height=\"388\" src=\"https://www.youtube.com/embed/K56soYl0U1w\" title=\"YouTube video player\" frameborder=\"0\" allow=\"accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture\" allowfullscreen></iframe></div>\n",
      url: 'https://www.youtube.com/watch?v=K56soYl0U1w',
      title: 'The Ramones - Blitzkrieg Bop (With Lyrics)'
    )
  end

  context 'Youtube channel' do
    let(:raw_feed) { rss_polling_file_fixture('youtube_channel.xml').read }
    let(:feed) { RSS::Parser.parse(raw_feed, false) }
    let(:raw_feed_item) { feed.entries.first }

    include_examples(
      'correctly parses the feed',
      content: "<div><iframe width=\"690\" height=\"388\" src=\"https://www.youtube.com/embed/peYYl2vrIt4\" title=\"YouTube video player\" frameborder=\"0\" allow=\"accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture\" allowfullscreen></iframe></div>\n",
      url: 'https://www.youtube.com/watch?v=peYYl2vrIt4',
      title: 'An Uncontroversial Opinion – AMD RX 6600 XT Announcement'
    )
  end
end
