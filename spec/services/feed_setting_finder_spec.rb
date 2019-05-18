# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DiscourseWellfed::FeedSettingFinder do
  before do
    SiteSetting.wellfed_feed_setting = [
      ['https://www.withwww.com/feed', 'system'],
      ['https://withoutwww.com/feed', 'system'],
      ['https://blog.discourse.org/feed/', 'discourse'],
    ].to_yaml
  end

  describe '.by_embed_url' do
    it 'finds the feed setting with the same host' do
      setting = DiscourseWellfed::FeedSettingFinder.by_embed_url('https://blog.discourse.org/2018/03/')
      expect(setting.feed_url).to eq('https://blog.discourse.org/feed/')
    end

    it 'neglects www in the url' do
      setting = DiscourseWellfed::FeedSettingFinder.by_embed_url('https://withwww.com/a-post/')
      expect(setting.feed_url).to eq('https://www.withwww.com/feed')

      setting = DiscourseWellfed::FeedSettingFinder.by_embed_url('https://www.withoutwww.com/a-post/')
      expect(setting.feed_url).to eq('https://withoutwww.com/feed')
    end
  end
end
