# frozen_string_literal: true

require "rss"

module Jobs
  module DiscourseRssPolling
    class PollFeed < ::Jobs::Base
      def execute(args)
        return unless SiteSetting.rss_polling_enabled

        return unless @author = User.find_by_username(args[:author_username])

        @discourse_category_id = args[:discourse_category_id]
        return if @discourse_category_id.present? && !Category.exists?(@discourse_category_id)

        @feed_url = args[:feed_url]
        @discourse_tags = args[:discourse_tags]
        @feed_category_filter = args[:feed_category_filter]

        poll_feed if not_polled_recently?
      end

      private

      attr_reader :feed_url, :author, :discourse_category_id, :discourse_tags, :feed_category_filter

      def feed_key
        "rss-polling-feed-polled:#{Digest::SHA1.hexdigest(feed_url)}"
      end

      def not_polled_recently?
        Discourse.redis.set(
          feed_key,
          1,
          ex: SiteSetting.rss_polling_frequency.minutes - 10.seconds,
          nx: true,
        )
      end

      def poll_feed
        topics_polled_from_feed.each do |topic|
          next if !topic.content.present?
          if (
               feed_category_filter.present? &&
                 topic.categories.none? { |c| c.include?(feed_category_filter) }
             )
            next
          end

          cook_method = topic.is_youtube? ? Post.cook_methods[:regular] : nil

          TopicEmbed.import(
            author,
            topic.url,
            topic.title,
            CGI.unescapeHTML(topic.content),
            category_id: discourse_category_id,
            tags: discourse_tags,
            cook_method: cook_method,
          )
        end
      end

      def topics_polled_from_feed
        raw_feed = fetch_raw_feed
        return [] if raw_feed.blank?

        parsed_feed = RSS::Parser.parse(raw_feed, false)
        return [] if parsed_feed.blank?

        parsed_feed.items.map { |item| ::DiscourseRssPolling::FeedItem.new(item) }
      rescue RSS::NotWellFormedError, RSS::InvalidRSSError
        []
      end

      def fetch_raw_feed
        final_destination = FinalDestination.new(@feed_url)
        feed_final_url = final_destination.resolve
        return nil unless final_destination.status == :resolved

        Excon.new(feed_final_url.to_s).request(method: :get, expects: 200).body
      rescue Excon::Error::HTTPStatus
        nil
      end
    end
  end
end
