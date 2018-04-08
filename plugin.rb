# name: discourse-wellfed
# about: This plugin enables support for importing embedded content from multiple RSS/ATOM feeds
# version: 0.0.1
# authors: xrav3nz

enabled_site_setting :wellfed_enabled

load File.expand_path('../lib/discourse_wellfed/engine.rb', __FILE__)

add_admin_route 'wellfed.title', 'wellfed'

Discourse::Application.routes.append do
  mount ::DiscourseWellfed::Engine, at: '/admin/plugins/wellfed'
end
