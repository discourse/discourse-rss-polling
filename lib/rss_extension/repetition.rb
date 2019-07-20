# frozen_string_literal: true

module RSSExtension
  # This is inferred from reading the Ruby RSS module's source code, I am not
  # entirely sure if this is the correct interpretation.
  module Repetition
    ZERO_OR_ONE = '?'
    ZERO_OR_MORE = '*'

    # this looks like the default, from
    # https://github.com/ruby/rss/blob/79273c1b0c8561a1f3b791b34c204a2d863f24e1/lib/rss/rss.rb#L949
    ONE_OR_MORE = '+'
  end
end
