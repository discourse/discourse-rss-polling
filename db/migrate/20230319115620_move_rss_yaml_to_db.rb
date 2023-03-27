# frozen_string_literal: true

class MoveRssYamlToDb < ActiveRecord::Migration[7.0]
  def up
    feeds = YAML.safe_load(SiteSetting.rss_polling_feed_setting)
    feeds.each do |feed|
      # ["https://blog.codinghorror.com/rss/", "system", 14, ["welcome", "another"], "category_filter"]
      tags = feed[3].nil? ? nil : feed[3].join(",")

      DiscourseRssPolling::RssFeed.create(
        url: feed[0],
        author: feed[1],
        category_id: feed[2],
        tags: tags,
        category_filter: feed[4],
      )
    end
  end
end
