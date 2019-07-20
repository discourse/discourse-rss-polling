# frozen_string_literal: true

require 'rss'

module RSSExtension
  module Media
    class BaseModel < RSS::Element
      ELEMENTS = []

      class << self
        def install_text_element(name)
          prefixed_name = with_prefix(name)
          super(name, URI, nil, prefixed_name)
          RSS::BaseListener.install_get_text_element(URI, name, prefixed_name)
        end

        def install_class_name(on:)
          top_level_namespaced_name = "::#{self.name}"
          on.install_class_name(URI, tag_name, top_level_namespaced_name)
        end

        def install_have_child_element(repetition:, on:)
          if on.respond_to?('each')
            on.each do |klass|
              install_have_child_element(
                repetition: repetition,
                on: klass,
              )
            end
          else
            on.install_have_child_element(
              tag_name,
              URI,
              repetition,
              with_prefix(tag_name)
            )
          end
        end

        def required_prefix
          PREFIX
        end

        def required_uri
          URI
        end

        private

        def with_prefix(name)
          "#{PREFIX}_#{name}"
        end
      end

      def full_name
        tag_name_with_prefix(PREFIX)
      end
    end
  end
end
