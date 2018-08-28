require 'rails_helper'

RSpec.describe Jobs::DiscourseWellfed::FixTopicEmbedAuthors do
  let(:job) { Jobs::DiscourseWellfed::FixTopicEmbedAuthors.new }

  describe '#execute' do
    before do
      SiteSetting.queue_jobs = true
    end

    it 'makes sure the topic and first post have the same author' do
      Sidekiq::Testing.fake! do
        topic_embed = create_mismatched_topic_embed
        post = topic_embed.post
        expected_user = post.user

        expect(post.user).to_not eq(post.topic.user)

        job.execute({})

        post.reload
        expect(post.user).to eq(expected_user)
        expect(post.user).to eq(post.topic.user)
      end
    end

    def create_mismatched_topic_embed
      topic_embed = Fabricate(:topic_embed, embed_url: 'http://example.com/post/248')
      new_user = Fabricate(:user)

      topic_embed.post.revise(
        Discourse.system_user,
        { user_id: new_user.id },
        skip_validations: true,
        bypass_rate_limiter: true
      )

      topic_embed
    end
  end
end
