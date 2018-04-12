require 'rails_helper'

RSpec.describe Jobs::DiscourseWellfed::PollAllFeeds do
  let(:job) { Jobs::DiscourseWellfed::PollAllFeeds.new }

  describe '#execute' do
    before do
      SiteSetting.wellfed_feed_setting = [
        ['https://www.example.com/feed', 'system'],
        ['https://blog.discourse.org/feed/', 'discourse'],
      ].to_yaml

      SiteSetting.queue_jobs = true
      $redis.del('wellfed-feeds-polled')
    end

    it 'queues correct PollFeed jobs' do
      Sidekiq::Testing.fake! do
        expect { job.execute({}) }.to change { Jobs::DiscourseWellfed::PollFeed.jobs.size }.by(2)

        enqueued_jobs_args = Jobs::DiscourseWellfed::PollFeed.jobs.last(2).map { |job| job['args'][0] }

        expect(enqueued_jobs_args[0]['feed_url']).to eq('https://www.example.com/feed')
        expect(enqueued_jobs_args[0]['author_username']).to eq('system')

        expect(enqueued_jobs_args[1]['feed_url']).to eq('https://blog.discourse.org/feed/')
        expect(enqueued_jobs_args[1]['author_username']).to eq('discourse')
      end
    end

    it 'is rate limited' do
      Sidekiq::Testing.fake! do
        expect { job.execute({}) }.to change { Jobs::DiscourseWellfed::PollFeed.jobs.size }.by(2)
        expect { job.execute({}) }.to_not change { Jobs::DiscourseWellfed::PollFeed.jobs.size }
      end
    end
  end
end
