# frozen_string_literal: true

module DiscourseRssPolling
  class FeedSettingFinder
    def self.by_embed_url(embed_url)
      host = URI.parse(embed_url).host.sub(/^www\./, '')
      new.where { |feed_url, *_| feed_url.include?(host) }.take
    end

    def self.all
      new.all
    end

    def initialize
      @condition = Proc.new { |*| true }
    end

    def where(&block)
      @condition = block
      self
    end

    def all
      YAML.load(SiteSetting.rss_polling_feed_setting)
        .select(&@condition)
        .map { |(feed_url, author_username, feed_category_filter)| FeedSetting.new(feed_url: feed_url, author_username: author_username, feed_category_filter: feed_category_filter) }
    end

    def take
      all&.first
    end
  end
end
