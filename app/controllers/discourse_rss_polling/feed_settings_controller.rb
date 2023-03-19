# frozen_string_literal: true

module DiscourseRssPolling
  class FeedSettingsController < Admin::AdminController
    requires_plugin "discourse-rss-polling"

    def show
      render json: FeedSettingFinder.all
    end

    def update

      if feed_setting_params.presence
        feed_setting_params.each do |feed|
          rss_feed = RssFeed.find_by(url: feed['feed_url'])
          # Temporary until we start using IDs from the db
          # and can update individual items
          if rss_feed
            rss_feed.update(
              url: feed['feed_url'],
              author: feed['author_username'],
              category_id: feed['discourse_category_id'],
              tags: feed['discourse_tags'].nil? ? nil : feed['discourse_tags'].join(','),
              category_filter: feed['feed_category_filter'],
            )
          else
            RssFeed.create(
              url: feed['feed_url'],
              author: feed['author_username'],
              category_id: feed['discourse_category_id'],
              tags: feed['discourse_tags'].nil? ? nil : feed['discourse_tags'].join(','),
              category_filter: feed['feed_category_filter'],
            )
          end
        end
      end

      # delete?

      render json: FeedSettingFinder.all
    end

    private

    def feed_setting_params
      params.require(:feed_settings)
    end
  end
end
