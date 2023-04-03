# frozen_string_literal: true

module DiscourseRssPolling
  class FeedSettingsController < Admin::AdminController
    requires_plugin "discourse-rss-polling"

    def show
      render json: FeedSettingFinder.all
    end

    def update
      if params[:feed_settings] == []
        RssFeed.destroy_all
      else
        # Temporary until we start using IDs from the db
        # and can update individual items
        if feed_setting_params.presence
          current_feeds = RssFeed.all.as_json
          feed_setting_params.each do |feed|
            current_feeds.delete_if do |h|
              h["url"] == feed["feed_url"] &&
                h["category_id"].to_i == feed["discourse_category_id"].to_i &&
                h["category_filter"] == feed["feed_category_filter"]
            end
            rss_feed =
              RssFeed.find_by(
                url: feed["feed_url"],
                category_id: feed["discourse_category_id"],
                category_filter: feed["feed_category_filter"],
              )
            if rss_feed
              rss_feed.update(
                url: feed["feed_url"],
                author: feed["author_username"],
                category_id: feed["discourse_category_id"],
                tags: feed["discourse_tags"].nil? ? nil : feed["discourse_tags"].join(","),
                category_filter: feed["feed_category_filter"],
              )
            else
              RssFeed.create(
                url: feed["feed_url"],
                author: feed["author_username"],
                category_id: feed["discourse_category_id"],
                tags: feed["discourse_tags"].nil? ? nil : feed["discourse_tags"].join(","),
                category_filter: feed["feed_category_filter"],
              )
            end
          end

          # Delete any remaining feeds
          current_feeds.each { |feed| RssFeed.destroy_by(id: feed["id"]) }
        end
      end

      render json: FeedSettingFinder.all
    end

    private

    def feed_setting_params
      params.require(:feed_settings)
    end
  end
end
