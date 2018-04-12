module Jobs
  module DiscourseWellfed
    class PollAllFeeds < ::Jobs::Scheduled
      every 5.minutes

      def execute(args)
        ::DiscourseWellfed::FeedSettingFinder.all.each(&:poll)
      end
    end
  end
end
