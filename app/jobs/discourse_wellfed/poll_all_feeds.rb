# frozen_string_literal: true

module Jobs
  module DiscourseWellfed
    class PollAllFeeds < ::Jobs::Scheduled
      every 5.minutes

      def execute(args)
        poll_all_feeds if not_polled_recently?
      end

      private

      def poll_all_feeds
        ::DiscourseWellfed::FeedSettingFinder.all.each(&:poll)
      end

      REDIS_KEY = 'wellfed-feeds-polled'

      def not_polled_recently?
        $redis.set(REDIS_KEY, 1, ex: SiteSetting.wellfed_polling_frequency.minutes - 10.seconds, nx: true)
      end
    end
  end
end
