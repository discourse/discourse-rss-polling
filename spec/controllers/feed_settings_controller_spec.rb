require 'rails_helper'

describe DiscourseWellfed::FeedSettingsController do
  routes { DiscourseWellfed::Engine.routes }

  let!(:user) { log_in(:admin) }

  before do
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

      get :show, format: :json

      expect(response).to be_success
      expect(response.body).to eq(expected_json)
    end
  end
end
