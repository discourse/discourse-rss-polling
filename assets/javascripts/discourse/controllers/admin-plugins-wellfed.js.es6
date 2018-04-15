import WellfedFeedSettings from 'discourse/plugins/discourse-wellfed/admin/models/wellfed-feed-settings';

export default Ember.Controller.extend({
  feedSettings: Ember.computed.alias('model'),
  saving: false,

  actions: {
    create() {
      this.get('feedSettings').addObject({ feed_url: null, author_username: null });
    },

    destroy(feedSetting) {
      this.get('feedSettings').removeObject(feedSetting);
    },

    update() {
      this.set('saving', true);

      WellfedFeedSettings.update(this.get('feedSettings'))
        .then((updatedSettings) => {
          this.set('feedSettings', updatedSettings['feed_settings']);
        })
        .finally(() => {
          this.set('saving', false);
        });
    }
  }
});
