# frozen_string_literal: true

module DiscourseWellfed
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
        Jobs::DiscourseWellfed::PollFeed.new.execute(feed_url: feed_url, author_username: author_username)
      else
        Jobs.enqueue('DiscourseWellfed::PollFeed', feed_url: feed_url, author_username: author_username)
      end
    end
  end
end
