# frozen_string_literal: true

require 'rss'

module Jobs
  module DiscourseRssPolling
    class PollFeed < ::Jobs::Base
      def execute(args)
        return unless SiteSetting.rss_polling_enabled

        @feed_url = args[:feed_url]
        @author = User.find_by_username(args[:author_username])

        poll_feed if not_polled_recently?
      end

      private

      attr_reader :feed_url, :author

      def feed_key
        "rss-polling-feed-polled:#{Digest::SHA1.hexdigest(feed_url)}"
      end

      def not_polled_recently?
        Discourse.redis.set(feed_key, 1, ex: SiteSetting.rss_polling_frequency.minutes - 10.seconds, nx: true)
      end

      def poll_feed
        topics_polled_from_feed.each do |topic|
          TopicEmbed.import(author, topic.url, CGI.unescapeHTML(topic.title), CGI.unescapeHTML(topic.content)) if topic.content.present?
        end
      end

      def topics_polled_from_feed
        raw_feed = fetch_raw_feed
        return [] if raw_feed.blank?

        RSS::Parser.parse(raw_feed).items.map { |item| ::DiscourseRssPolling::FeedItem.new(item) }
      rescue RSS::NotWellFormedError, RSS::InvalidRSSError
        []
      end

      def fetch_raw_feed
        final_destination = FinalDestination.new(@feed_url, verbose: true)
        feed_final_url = final_destination.resolve
        return nil unless final_destination.status == :resolved

        Excon.new(feed_final_url.to_s).request(method: :get, expects: 200).body
      rescue Excon::Error::HTTPStatus
        nil
      end
    end
  end
end
