# frozen_string_literal: true

require 'rss'
require 'rss_extension/repetition'
require 'rss_extension/media/base_model'

module RSSExtension
  module Media
    class Group < BaseModel
      @tag_name = 'group'

      install_text_element 'description'
      install_text_element 'title'

      install_class_name on: RSS::BaseListener
      install_have_child_element(
        repetition: Repetition::ZERO_OR_ONE,
        on: [RSS::Atom::Feed::Entry, RSS::Atom::Entry]
      )
    end
  end
end
