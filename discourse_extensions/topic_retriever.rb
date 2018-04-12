class TopicRetriever
  private

  alias_method :fallback_to_default_retrieve, :perform_retrieve

  def perform_retrieve
    fallback_to_default_retrieve unless perform_wellfed_retrieve
  end

  def perform_wellfed_retrieve
    return false unless SiteSetting.wellfed_enabled?
    return true if TopicEmbed.where(embed_url: @embed_url).exists?

    DiscourseWellfed::FeedSettingFinder.by_embed_url(@embed_url)&.poll(inline: true)

    TopicEmbed.where(embed_url: @embed_url).exists?
  end
end
