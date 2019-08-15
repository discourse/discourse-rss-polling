# frozen_string_literal: true

require 'rails_helper'

describe DiscourseWellfed::FeedSettingsController do
  let!(:admin) { Fabricate(:admin) }

  before do
    sign_in(admin)

    SiteSetting.wellfed_enabled = true
    SiteSetting.wellfed_feed_setting = [
      ['https://www.example.com/feed', 'system'],
      ['https://blog.discourse.org/feed/', 'discourse'],
    ].to_yaml
  end

  describe '#show' do
    it 'returns the serialized feed settings' do
      expected_json = ActiveModel::ArraySerializer.new(
        DiscourseWellfed::FeedSettingFinder.all,
        root: :feed_settings,
      ).to_json

      get '/admin/plugins/wellfed/feed_settings.json'

      expect(response.status).to eq(200)
      expect(response.body).to eq(expected_json)
    end
  end

  describe '#update' do
    it 'updates SiteSetting.wellfed_feed_setting' do
      put '/admin/plugins/wellfed/feed_settings.json', params: {
        feed_settings: [
          {
            feed_url: 'https://www.newsite.com/feed',
            author_username: 'system'
          }
        ]
      }

      expect(response.status).to eq(200)
      expect(SiteSetting.wellfed_feed_setting).to eq([
        ['https://www.newsite.com/feed', 'system']
      ].to_yaml)
    end
  end
end
