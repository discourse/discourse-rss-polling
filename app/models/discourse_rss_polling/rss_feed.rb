# frozen_string_literal: true

module DiscourseRssPolling
  class RssFeed < ActiveRecord::Base
    validates :url, presence: true
  end
end
