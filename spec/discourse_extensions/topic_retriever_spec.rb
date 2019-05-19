# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TopicRetriever do
  let(:embed_url) { 'https://blog.discourse.org/2018/03/' }
  let(:author) { Fabricate(:user) }
  let(:topic_retriever) { TopicRetriever.new(embed_url, no_throttle: true) }
  let(:feed_url) { 'https://blog.discourse.org/feed/' }
  let!(:embeddable_host) { Fabricate(:embeddable_host, host: 'blog.discourse.org') }

  before do
    SiteSetting.wellfed_feed_setting = [[feed_url, author.username]].to_yaml
    SiteSetting.wellfed_enabled = true
  end

  describe '#retrieve' do
    it do
      $redis.del("wellfed-feed-polled:#{Digest::SHA1.hexdigest(feed_url)}")
      stub_request(:head, feed_url).to_return(status: 200, body: '')
      stub_request(:get, feed_url).to_return(status: 200, body: file_from_fixtures('feed.rss', 'feed'))

      expect { topic_retriever.retrieve }.to change { author.topics.count }

      topic = author.topics.last

      expect(topic.title).to eq('Poll Feed Spec Fixture')
      expect(topic.first_post.raw).to include('<p>This is the body &amp; content. </p>')
      expect(topic.topic_embed.embed_url).to eq('https://blog.discourse.org/2017/09/poll-feed-spec-fixture')
    end
  end
end
