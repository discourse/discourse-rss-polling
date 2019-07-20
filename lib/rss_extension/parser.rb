# frozen_string_literal: true

require 'rss'

module RSSExtension
  class Parser
    RUBY_VERSION_WITH_HASH_RSS_PARSER_OPTIONS = '2.6.0'

    class << self
      def parse(feed, validate: true, ignore_unknown_element: true)
        if parser_support_hash_options?
          RSS::Parser.parse(
            feed,
            validate: validate,
            ignore_unknown_element: ignore_unknown_element
          )
        else
          RSS::Parser.parse(feed, validate, ignore_unknown_element)
        end
      end

      private

      def parser_support_hash_options?
        if defined?(@parser_support_hash_options)
          @parser_support_hash_options
        else
          @parser_support_hash_options = Gem::Version.new(RUBY_VERSION) >=
            Gem::Version.new(RUBY_VERSION_WITH_HASH_RSS_PARSER_OPTIONS)
        end
      end
    end
  end
end
