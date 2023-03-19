# frozen_string_literal: true

class CreateDiscourseRssPollingRssFeeds < ActiveRecord::Migration[7.0]
  def change
    create_table :discourse_rss_polling_rss_feeds do |t|
      t.string :url, null: false
      t.string :category_filter
      t.string :author
      t.integer :category_id
      t.string :tags
      t.timestamps
    end
  end
end
