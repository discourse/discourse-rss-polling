import Controller from "@ember/controller";
import { action, set } from "@ember/object";
import { alias } from "@ember/object/computed";
import { service } from "@ember/service";
import { isBlank } from "@ember/utils";
import { observes } from "@ember-decorators/object";
import discourseComputed from "discourse-common/utils/decorators";
import { i18n } from "discourse-i18n";
import RssPollingFeedSettings from "../../admin/models/rss-polling-feed-settings";

export default class AdminPluginsRssPollingController extends Controller {
  @service dialog;
  @alias("model") feedSettings;

  saving = false;
  valid = false;

  @discourseComputed("valid", "saving")
  unsavable(valid, saving) {
    return !valid || saving;
  }

  // TODO: extract feed setting into its own component && more validation
  @observes("feedSettings.@each.{feed_url,author_username}")
  validate() {
    let overallValidity = true;

    this.get("feedSettings").forEach((feedSetting) => {
      const localValidity =
        !isBlank(feedSetting.feed_url) && !isBlank(feedSetting.author_username);
      set(feedSetting, "valid", localValidity);
      overallValidity = overallValidity && localValidity;
    });

    this.set("valid", overallValidity);
  }

  @action
  create() {
    this.get("feedSettings").addObject({
      feed_url: null,
      author_username: null,
      discourse_category_id: null,
      discourse_tags: null,
      feed_category_filter: null,
    });
  }

  @action
  destroyFeedSetting(feedSetting) {
    this.dialog.deleteConfirm({
      message: i18n("admin.rss_polling.destroy_feed.confirm"),
      didConfirm: () => {
        this.get("feedSettings").removeObject(feedSetting);
        this.send("update");
      },
    });
  }

  @action
  update() {
    this.set("saving", true);

    RssPollingFeedSettings.update(this.get("feedSettings"))
      .then((updatedSettings) => {
        this.set("feedSettings", updatedSettings["feed_settings"]);
      })
      .finally(() => {
        this.set("saving", false);
      });
  }

  @action
  updateAuthorUsername(setting, selected) {
    set(setting, "author_username", selected.firstObject);
  }
}
