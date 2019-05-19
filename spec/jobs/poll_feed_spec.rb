# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Jobs::DiscourseWellfed::PollFeed do
  let(:feed_url) { 'https://blog.discourse.org/feed/' }
  let(:author) { Fabricate(:user) }
  let(:raw_feed) { file_from_fixtures('feed.rss', 'feed') }
  let(:job) { Jobs::DiscourseWellfed::PollFeed.new }

  describe '#execute' do
    before do
      $redis.del("wellfed-feed-polled:#{Digest::SHA1.hexdigest(feed_url)}")
      stub_request(:head, feed_url).to_return(status: 200, body: '')
      stub_request(:get, feed_url).to_return(status: 200, body: raw_feed)
    end

    it 'creates a topic with the right title, content and author' do
      expect { job.execute(feed_url: feed_url, author_username: author.username) }.to change { author.topics.count }

      topic = author.topics.last

      expect(topic.title).to eq('Poll Feed Spec Fixture')
      expect(topic.first_post.raw).to include('<p>This is the body &amp; content. </p>')
      expect(topic.topic_embed.embed_url).to eq('https://blog.discourse.org/2017/09/poll-feed-spec-fixture')
    end

    it 'is rate limited by wellfed_polling_frequency' do
      2.times { job.execute(feed_url: feed_url, author_username: author.username) }

      expect(WebMock).to have_requested(:get, feed_url).once
    end
  end
end
