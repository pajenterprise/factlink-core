require 'pavlov_helper'
require_relative '../../../../app/interactors/queries/topics/dead_topic_with_authority_and_facts_count_by_topic'

describe Queries::Topics::DeadTopicWithAuthorityAndFactsCountByTopic do
  include PavlovSupport

  describe '#call' do
    let(:topic) { double(slug_title: mock, title: mock)}

    before do
      stub_classes 'DeadTopic'
      DeadTopic.stub(:new)
    end

    it 'calls the correct validation methods' do
      query = described_class.new alive_topic: nil

      expect{ query.call }.to raise_error(Pavlov::ValidationError, 'alive_topic should not be nil.')
    end

    it 'returns the topic' do
      facts_count = double
      current_user_authority = double
      current_user = mock(graph_user: mock)
      dead_topic = double
      pavlov_options = {current_user: current_user}

      Pavlov.stub(:old_query)
        .with(:'topics/facts_count', topic.slug_title, pavlov_options)
        .and_return(facts_count)

      Pavlov.stub(:old_query)
        .with(:authority_on_topic_for, topic, current_user.graph_user, pavlov_options)
        .and_return(current_user_authority)

      DeadTopic.stub(:new)
        .with(topic.slug_title, topic.title, current_user_authority, facts_count)
        .and_return(dead_topic)

      query = described_class.new alive_topic: topic, pavlov_options: pavlov_options

      expect(query.call).to eq dead_topic
    end
  end
end
