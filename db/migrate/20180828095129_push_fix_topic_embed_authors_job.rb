class PushFixTopicEmbedAuthorsJob < ActiveRecord::Migration[5.2]
  def change
    Jobs.enqueue('DiscourseWellfed::FixTopicEmbedAuthors')
  end
end
