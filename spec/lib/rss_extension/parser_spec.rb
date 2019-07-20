# frozen_string_literal: true

require 'rails_helper'
require 'rss_extension/parser'

INVALID_FEED = <<~XML
<rss version="2.0">
  <channel>
    <description>Description.</description>
    <link>http://www.example.com/</link>
    <item>
      <title>Item Title</title>
      <description>Item description.</description>
      <link>http://www.example.com/item.htm</link>
    </item>
  </channel>
</rss>
XML

FEED_WITH_UNKNOWN_ELEMENT = <<~XML
<rss version="2.0">
  <channel>
    <title>Title</title>
    <description>Description.</description>
    <link>http://www.example.com/</link>
    <item>
      <title>Item Title</title>
      <description>Item description.</description>
      <unknownElement>Unknown element.</unknownElement>
    </item>
  </channel>
</rss>
XML

RSpec.describe RSSExtension::Parser do
  describe '.parse' do
    it 'correctly handles `validate` option' do
      expect { RSSExtension::Parser.parse(INVALID_FEED) }
        .to raise_error(RSS::MissingTagError), 'validates by default'

      expect { RSSExtension::Parser.parse(INVALID_FEED, validate: true) }
        .to raise_error(RSS::MissingTagError)

      expect { RSSExtension::Parser.parse(INVALID_FEED, validate: false) }
        .not_to raise_error
    end

    it 'correctly handles `ignore_unknown_element` option' do
      expect { RSSExtension::Parser.parse(FEED_WITH_UNKNOWN_ELEMENT) }
        .not_to raise_error, 'ignores unknown element by default'

      expect { RSSExtension::Parser.parse(FEED_WITH_UNKNOWN_ELEMENT, ignore_unknown_element: true) }
        .not_to raise_error

      expect { RSSExtension::Parser.parse(FEED_WITH_UNKNOWN_ELEMENT, ignore_unknown_element: false) }
        .to raise_error(RSS::NotExpectedTagError)
    end
  end
end
