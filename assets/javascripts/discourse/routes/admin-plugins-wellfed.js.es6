import WellfedFeedSettings from 'discourse/plugins/discourse-wellfed/admin/models/wellfed-feed-settings';

export default Discourse.Route.extend({
  model() {
    return WellfedFeedSettings.show().then(result => result.feed_settings);
  },

  setupController(controller, model) {
    controller.setProperties({
      feedSettings: model
    });
  }
});
