# frozen_string_literal: true

# name: discourse-rss-polling
# about: This plugin enables support for importing embedded content from multiple RSS/ATOM feeds
# version: 0.0.1
# authors: xrav3nz
# url: https://github.com/discourse/discourse-rss-polling

load File.expand_path(File.join("..", "lib", "discourse_rss_polling", "engine.rb"), __FILE__)

enabled_site_setting :rss_polling_enabled
add_admin_route "rss_polling.title", "rss_polling"
register_asset "stylesheets/rss-polling.scss"
register_svg_icon "save" if respond_to?(:register_svg_icon)

Discourse::Application.routes.append do
  mount ::DiscourseRssPolling::Engine, at: "/admin/plugins/rss_polling"
end
