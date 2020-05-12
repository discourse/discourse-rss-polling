import RssPollingFeedSettings from "../../admin/models/rss-polling-feed-settings";
import DiscourseRoute from "discourse/routes/discourse";

export default DiscourseRoute.extend({
  model() {
    return RssPollingFeedSettings.show().then(result => result.feed_settings);
  },

  setupController(controller, model) {
    controller.setProperties({
      model: model
    });
  }
});
