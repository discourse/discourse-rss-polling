# frozen_string_literal: true

require 'rails_helper'
require 'rss'

RSpec.describe DiscourseWellfed::FeedItem do
  context 'for ATOM feed' do
    let(:atom_feed) { RSS::Parser.parse(file_from_fixtures('feed.atom', 'feed'), false) }
    let(:feed_item) { DiscourseWellfed::FeedItem.new(atom_feed.items.first) }

    describe '#content' do
      it { expect(feed_item.content).to eq('<p>This is the body &amp; content. </p>') }
    end

    describe '#url' do
      it { expect(feed_item.url).to eq('https://blog.discourse.org/2017/09/poll-feed-spec-fixture/') }
    end

    describe '#title' do
      it { expect(feed_item.title).to eq('Poll Feed Spec Fixture') }
    end
  end

  context 'for RSS feed' do
    let(:rss_feed) { RSS::Parser.parse(file_from_fixtures('feed.rss', 'feed'), false) }
    let(:feed_item) { DiscourseWellfed::FeedItem.new(rss_feed.items.first) }

    describe '#content' do
      it { expect(feed_item.content).to eq('<p>This is the body &amp; content. </p>') }
    end

    describe '#url' do
      it { expect(feed_item.url).to eq('https://blog.discourse.org/2017/09/poll-feed-spec-fixture/') }
    end

    describe '#title' do
      it { expect(feed_item.title).to eq('Poll Feed Spec Fixture') }
    end
  end
end
