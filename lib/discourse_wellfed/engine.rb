# frozen_string_literal: true

module DiscourseWellfed
  class Engine < ::Rails::Engine
    engine_name "discourse_wellfed"
    isolate_namespace DiscourseWellfed

    config.to_prepare do
      Dir[File.expand_path(File.join('..', '..', '..', 'app', 'jobs', 'discourse_wellfed', '*.rb'), __FILE__)].each do |job|
        require_dependency job
      end
    end
  end
end
