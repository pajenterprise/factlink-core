require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/topics/unfavourite'

describe Interactors::Topics::Unfavourite do
  include PavlovSupport

  describe '#authorized?' do
    before do
      described_class.any_instance
        .should_receive(:validate)
        .and_return(true)
    end

    it 'throws when no current_user' do
      expect { described_class.new mock, mock }
        .to raise_error Pavlov::AccessDenied,'Unauthorized'
    end

    it 'throws when updating someone else\'s favourite' do
      username = mock
      other_username = mock
      current_user = mock(username: username)

      expect { described_class.new other_username, mock, {current_user: current_user} }
        .to raise_error Pavlov::AccessDenied,'Unauthorized'
    end

    it 'doesn\'t throw when updating your own favourite' do
      username = mock
      current_user = mock(username: username)

      described_class.new username, mock, {current_user: current_user}
    end
  end

  describe '.new' do
    before do
      described_class.any_instance
        .should_receive(:authorized?)
        .and_return(true)
      described_class.any_instance
        .should_receive(:validate)
        .and_return(true)
    end

    it 'returns an object' do
      interactor = described_class.new mock, mock

      expect(interactor).to_not be_nil
    end
  end

  describe '#execute' do
    before do
      described_class.any_instance
        .should_receive(:authorized?)
        .and_return(true)
      described_class.any_instance
        .should_receive(:validate)
        .and_return(true)
    end

    it 'calls a command to unfavourite topic' do
      user_name = mock
      slug_title = mock
      interactor = described_class.new user_name, slug_title
      user = mock(graph_user_id: mock)
      topic = mock(id: mock)

      interactor.should_receive(:query)
        .with(:'user_by_username', user_name)
        .and_return(user)
      interactor.should_receive(:query)
        .with(:'topics/by_slug_title', slug_title)
        .and_return(topic)
      interactor.should_receive(:command)
        .with(:'topics/unfavourite', user.graph_user_id, topic.id)

      result = interactor.execute

      expect(result).to eq nil
    end
  end

  describe '#validate' do
    before do
      described_class.any_instance
        .stub(:authorized?)
        .and_return(true)
    end

    it 'calls the correct validation methods' do
      user_name = mock
      slug_title = mock

      described_class.any_instance.should_receive(:validate_nonempty_string)
        .with(:user_name, user_name)
      described_class.any_instance.should_receive(:validate_nonempty_string)
        .with(:slug_title, slug_title)

      interactor = described_class.new user_name, slug_title
    end
  end
end
