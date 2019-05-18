# frozen_string_literal: true

module DiscourseWellfed
  class FeedSettingsController < Admin::AdminController
    requires_plugin 'discourse-wellfed'

    def show
      render json: FeedSettingFinder.all
    end

    def update
      # TODO: validator? separate persister?
      new_feed_settings = (update_params.presence || []).map do |feed_setting|
        feed_setting.values_at(:feed_url, :author_username)
      end

      SiteSetting.wellfed_feed_setting = new_feed_settings.to_yaml

      render json: FeedSettingFinder.all
    end

    private

    def update_params
      params.require(:feed_settings)
    end
  end
end
