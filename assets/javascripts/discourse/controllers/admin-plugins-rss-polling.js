import Controller from "@ember/controller";
import RssPollingFeedSettings from "../../admin/models/rss-polling-feed-settings";
import { set } from "@ember/object";
import { alias } from "@ember/object/computed";
import discourseComputed, { observes } from "discourse-common/utils/decorators";
import { isBlank } from "@ember/utils";

export default Controller.extend({
  feedSettings: alias("model"),
  saving: false,
  valid: false,

  @discourseComputed("valid", "saving")
  unsavable(valid, saving) {
    return !valid || saving;
  },

  // TODO: extract feed setting into its own component && more validation
  @observes("feedSettings.@each.{feed_url,author_username}")
  validate() {
    let overallValidity = true;

    this.get("feedSettings").forEach((feedSetting) => {
      const localValidity =
        !isBlank(feedSetting.feed_url) &&
        !isBlank(feedSetting.author_username);
      set(feedSetting, "valid", localValidity);
      overallValidity = overallValidity && localValidity;
    });

    this.set("valid", overallValidity);
  },

  actions: {
    create() {
      this.get("feedSettings").addObject({
        feed_url: null,
        author_username: null,
        discourse_category_id: null,
        discourse_tags: null,
        feed_category_filter: null,
      });
    },

    destroy(feedSetting) {
      this.get("feedSettings").removeObject(feedSetting);
      this.send("update");
    },

    update() {
      this.set("saving", true);

      RssPollingFeedSettings.update(this.get("feedSettings"))
        .then((updatedSettings) => {
          this.set("feedSettings", updatedSettings["feed_settings"]);
        })
        .finally(() => {
          this.set("saving", false);
        });
    },

    updateAuthorUsername(setting, selected) {
      set(setting, "author_username", selected.firstObject);
    },
  },
});
