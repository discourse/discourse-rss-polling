# frozen_string_literal: true

module DiscourseRssPolling
  class FeedSetting
    include ActiveModel::Serialization

    attr_accessor(
      :feed_url,
      :author_username,
      :start_date,
    )

    def initialize(feed_url:, author_username:, start_date:)
      @feed_url = feed_url
      @author_username = author_username
      @start_date = start_date
    end

    def poll(inline: false)
      if inline
        Jobs::DiscourseRssPolling::PollFeed.new.execute(feed_url: feed_url, author_username: author_username, start_date: start_date)
      else
        Jobs.enqueue('DiscourseRssPolling::PollFeed', feed_url: feed_url, author_username: author_username, start_date: start_date)
      end
    end
  end
end
