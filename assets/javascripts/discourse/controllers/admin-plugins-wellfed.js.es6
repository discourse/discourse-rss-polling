import WellfedFeedSettings from 'discourse/plugins/discourse-wellfed/admin/models/wellfed-feed-settings';
import { default as computed, observes } from 'ember-addons/ember-computed-decorators';


export default Ember.Controller.extend({
  feedSettings: Ember.computed.alias('model'),
  saving: false,
  valid: false,

  @computed('valid', 'saving')
  unsavable(valid, saving) {
    return !valid || saving;
  },

  // TODO: extract feed setting into its own component && more validation
  @observes('feedSettings.@each.{feed_url,author_username}')
  validate() {
    let overallVaildity = true;

    this.get('feedSettings').forEach(feedSetting => {
      const localValidity = !Ember.isBlank(feedSetting.feed_url) && !Ember.isBlank(feedSetting.author_username);
      Ember.set(feedSetting, 'valid', localValidity);
      overallVaildity = overallVaildity && localValidity;
    });

    this.set('valid', overallVaildity);
  },

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
