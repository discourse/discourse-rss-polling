module DiscourseWellfed
  class FeedSetting
    attr_accessor(
      :feed_url,
      :author_username,
    )

    def initialize(feed_url:, author_username:)
      @feed_url = feed_url
      @author_username = @author_username
    end
  end
end
