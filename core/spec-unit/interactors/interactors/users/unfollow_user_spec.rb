require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/users/unfollow_user'

describe Interactors::Users::UnfollowUser do
  include PavlovSupport

  describe '#authorized?' do
    it 'throws when no current_user' do
      expect do
        described_class.new(username: 'bar').call
      end.to raise_error Pavlov::AccessDenied, 'Unauthorized'
    end
  end

  describe '#call' do
    it 'calls a command to unfollow' do
      username = 'henk'
      user = double(graph_user_id: double, username: 'jan')
      pavlov_options = { current_user: user }
      user_to_unfollow = double(graph_user_id: double)
      interactor = described_class.new username: username,
                                       pavlov_options: pavlov_options

      Pavlov.should_receive(:query)
            .with(:'user_by_username',
                      username: username, pavlov_options: pavlov_options)
            .and_return(user_to_unfollow)
      Pavlov.should_receive(:command)
            .with(:'users/unfollow_user',
                      graph_user_id: user.graph_user_id,
                      user_to_unfollow_graph_user_id: user_to_unfollow.graph_user_id,
                      pavlov_options: pavlov_options)

      expect(interactor.call).to eq nil
    end
  end

  describe 'validations' do
    it 'validates username' do
      expect_validating(username: 12)
        .to fail_validation 'username should be a nonempty string.'
    end
  end
end
