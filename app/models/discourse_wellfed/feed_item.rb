# frozen_string_literal: true

require_dependency 'feed_item_accessor'

module DiscourseWellfed
  class FeedItem
    def initialize(rss_item, accessor = ::FeedItemAccessor)
      @rss_item = rss_item
      @accessor = accessor.new(rss_item)
    end

    def url
      url?(@accessor.link) ? @accessor.link : @accessor.element_content(:id)
    end

    def content
      content = first_non_nil_proc_result(content_finder_procs)
      content.force_encoding('UTF-8').scrub unless content.nil?
    end

    def title
      title = first_non_nil_proc_result(title_finder_procs)
      title.force_encoding('UTF-8').scrub unless title.nil?
    end

    private

    def content_finder_procs
      [
        accessor_content_proc(:content_encoded),
        accessor_content_proc(:content),
        accessor_content_proc(:description),
        media_group_element_proc(:media_description),
      ]
    end

    def title_finder_procs
      [
        accessor_content_proc(:title),
        media_group_element_proc(:media_title),
      ]
    end

    def media_group_element_proc(tag_name)
      Proc.new do
        if @rss_item.respond_to?(:media_group)
          @rss_item.media_group&.public_send(tag_name)
        end
      end
    end

    def accessor_content_proc(tag_name)
      Proc.new { @accessor.element_content(tag_name) }
    end

    def first_non_nil_proc_result(procs)
      procs.lazy.map(&:call).find { |result| !result.nil? }
    end

    def url?(link)
      link.present? && link =~ /^https?\:\/\//
    end
  end
end
