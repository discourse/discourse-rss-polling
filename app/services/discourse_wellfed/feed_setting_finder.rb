module DiscourseWellfed
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
      YAML.load(SiteSetting.wellfed_feed_setting)
        .select(&@condition)
        .map { |(feed_url, author_username)| FeedSetting.new(feed_url: feed_url, author_username: author_username) }
    end

    def take
      all&.first
    end
  end
end
