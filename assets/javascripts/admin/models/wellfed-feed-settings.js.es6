import { ajax } from 'discourse/lib/ajax';

export default {
  show() {
    return ajax('/admin/plugins/wellfed/feed_settings.json');
  }
};
