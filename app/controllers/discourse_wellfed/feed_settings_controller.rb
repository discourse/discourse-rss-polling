module DiscourseWellfed
  class FeedSettingsController < Admin::AdminController
    requires_plugin 'discourse-wellfed'

    def show
      render json: FeedSettingFinder.all
    end
  end
end
