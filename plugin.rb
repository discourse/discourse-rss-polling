# frozen_string_literal: true

# name: discourse-wellfed
# about: This plugin enables support for importing embedded content from multiple RSS/ATOM feeds
# version: 0.0.1
# authors: xrav3nz

load File.expand_path(File.join('..', 'lib', 'discourse_wellfed', 'engine.rb'), __FILE__)

enabled_site_setting :wellfed_enabled
add_admin_route 'wellfed.title', 'wellfed'
register_asset 'stylesheets/wellfed.scss'
register_svg_icon 'save' if respond_to?(:register_svg_icon)

Discourse::Application.routes.append do
  mount ::DiscourseWellfed::Engine, at: '/admin/plugins/wellfed'
end
