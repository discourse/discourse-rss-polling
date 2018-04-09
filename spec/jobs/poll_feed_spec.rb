require 'rails_helper'

RSpec.describe DiscourseWellfed::PollFeed do
  let(:feed_url) { 'https://blog.discourse.org/feed/' }
  let(:author) { Fabricate(:user) }
  let(:raw_feed) { file_from_fixtures('feed.rss', 'feed') }
  let(:job) { DiscourseWellfed::PollFeed.new }

  before do
    stub_request(:get, feed_url).to_return(status: 200, body: raw_feed)
  end

  describe '#execute' do
    it 'creates a topic with the right title, content and author' do
      expect { job.execute(feed_url: feed_url, author_username: author.username) }.to change { author.topics.count }

      topic = author.topics.last

      expect(topic.title).to eq('Poll Feed Spec Fixture')
      expect(topic.first_post.raw).to include('<p>This is the body &amp; content. </p>')
      expect(topic.topic_embed.embed_url).to eq('https://blog.discourse.org/2017/09/poll-feed-spec-fixture')
    end
  end
end
