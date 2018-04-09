module DiscourseWellfed
  class PollFeed < ::Jobs::Base
    def execute(args)
      @feed_url = args[:feed_url]
      @author = User.find_by_username(args[:author_username])

      poll_feed if not_polled_recently?
    end

    private

    attr_reader :feed_url, :author

    def feed_key
      "feed-polled:#{Digest::SHA1.hexdigest(feed_url)}"
    end

    def not_polled_recently?
      $redis.set(feed_key, 1, ex: SiteSetting.wellfed_polling_frequency.minutes - 10.seconds, nx: true)
    end

    def poll_feed
      topics_polled_from_feed.each do |topic|
        TopicEmbed.import(author, topic.url, topic.title, CGI.unescapeHTML(topic.content)) if topic.content.present?
      end
    end

    def topics_polled_from_feed
      RSS::Parser.parse(fetch_raw_feed).items.map { |item| FeedItem.new(item) }
    rescue RSS::NotWellFormedError, RSS::InvalidRSSError
      []
    end

    def fetch_raw_feed
      raw_feed = ''
      FinalDestination.new(feed_url, verbose: true).get { |_response, chunk, _uri| raw_feed << chunk }
      raw_feed
    rescue Excon::Error::HTTPStatus
      nil
    end
  end
end
