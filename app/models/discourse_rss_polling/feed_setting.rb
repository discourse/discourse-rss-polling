# frozen_string_literal: true

module DiscourseRssPolling
  class FeedSetting
    include ActiveModel::Serialization

    attr_accessor(
      :feed_url,
      :author_username,
    )

    def initialize(feed_url:, author_username:)
      @feed_url = feed_url
      @author_username = author_username
    end

    def poll(inline: false)
      if inline
        Jobs::DiscourseRssPolling::PollFeed.new.execute(feed_url: feed_url, author_username: author_username)
      else
        Jobs.enqueue('DiscourseRssPolling::PollFeed', feed_url: feed_url, author_username: author_username)
      end
    end
  end
end
