# frozen_string_literal: true

require_dependency 'feed_item_accessor'

module DiscourseRssPolling
  class FeedItem
    def initialize(rss_item, accessor = ::FeedItemAccessor)
      @accessor = accessor.new(rss_item)
    end

    def url
      url?(@accessor.link) ? @accessor.link : @accessor.element_content(:id)
    end

    def content
      content = nil

      CONTENT_ELEMENT_TAG_NAMES.each do |tag_name|
        break if content = @accessor.element_content(tag_name)
      end

      return youtube_embed if is_youtube?

      content&.force_encoding('UTF-8')&.scrub
    end

    def title
      unclean_title = @accessor.element_content(:title)&.force_encoding('UTF-8')&.scrub
      unclean_title = TextCleaner.clean_title(TextSentinel.title_sentinel(unclean_title).text).presence
      CGI::unescapeHTML(unclean_title) if unclean_title
    end

    def categories
      @accessor.element_content(:categories).map { |c| c.content }
    end

    private

    # The tag name's relative order implies its priority.
    CONTENT_ELEMENT_TAG_NAMES = %i[
      content_encoded
      content
      description
      summary
    ]

    def url?(link)
      link.present? && link =~ /^https?\:\/\//
    end

    def is_youtube?
      url&.starts_with?('https://www.youtube.com/watch')
    end

    def youtube_embed
      <<~POSTCONTENT
        <div><iframe width="#{SiteSetting.max_image_width}" height="#{(SiteSetting.max_image_width / (16.0 / 9)).to_i}" src="https://www.youtube.com/embed/#{@accessor.element_content(:id).split(':').last}" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>
      POSTCONTENT
    end
  end
end
