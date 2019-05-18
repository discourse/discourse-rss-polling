# frozen_string_literal: true

module DiscourseWellfed
  class Engine < ::Rails::Engine
    engine_name "discourse_wellfed"
    isolate_namespace DiscourseWellfed

    config.to_prepare do
      Dir[File.expand_path(File.join('..', '..', '..', 'app', 'jobs', 'discourse_wellfed', '*.rb'), __FILE__)].each do |job|
        require_dependency job
      end

      Dir[File.expand_path(File.join('..', '..', '..', 'discourse_extensions', '*.rb'), __FILE__)].each do |discourse_extension|
        require_dependency discourse_extension
      end
    end
  end
end
