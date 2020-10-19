# frozen_string_literal: true

require 'rss'

module Jobs
  module DiscourseRssPolling
    class PollFeed < ::Jobs::Base
      def execute(args)
        return unless SiteSetting.rss_polling_enabled

        @feed_url = args[:feed_url]
        @author = User.find_by_username(args[:author_username])
        @start_date = args[:start_date]
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
        topics_polled_from_feed[0].each do |topic|
          next if Date.parse(@start_date) > topic.created_at
          raw = "#{topic.url}

          "

          category = EmbeddableHost.record_for_url(topic.url).category_id

          params = {
            raw: raw,
            category: category,
            archetype: 'regular',
            title: "#{topic.title() +' - '+ topics_polled_from_feed[1]}",
            topic_id: nil,
            featured_link: topic.url,
            created_at: topic.created_at
          }
          pm = NewPostManager.new(@author, params)
          pm.perform
        end
      end

      def topics_polled_from_feed
        raw_feed = fetch_raw_feed
        return [] if raw_feed.blank?
        parsed_feed = RSS::Parser.parse(raw_feed)
        return parsed_feed.items.map { |item| ::DiscourseRssPolling::FeedItem.new(item) } , parsed_feed.channel.title
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
