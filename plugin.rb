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

after_initialize do
  Dir[File.expand_path(File.join('..', 'app', 'jobs', 'discourse_wellfed', '*.rb'), __FILE__)].each do |job|
    require_dependency job
  end
end
