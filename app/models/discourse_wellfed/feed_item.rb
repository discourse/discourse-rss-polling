require_dependency 'feed_item_accessor'

module DiscourseWellfed
  class FeedItem
    def initialize(rss_item, accessor = ::FeedItemAccessor)
      @accessor = accessor.new(rss_item)
    end

    def url
      url?(@accessor.link) ? @accessor.link : @accessor.element_content(:id)
    end

    def content
      content = nil

      %i[content_encoded content description].each do |content_element_name|
        content ||= @accessor.element_content(content_element_name)
      end

      content&.force_encoding('UTF-8')&.scrub
    end

    def title
      @accessor.element_content(:title).force_encoding('UTF-8').scrub
    end

    private

    def url?(link)
      link.present? && link =~ /^https?\:\/\//
    end
  end
end
