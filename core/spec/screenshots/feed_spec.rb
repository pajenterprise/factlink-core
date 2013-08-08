require 'screenshot_helper'

describe "factlink", type: :feature do
  include Screenshots::DiscussionHelper
  include Acceptance::ChannelHelper

  before do
    @user = sign_in_user create :active_user
    @user2 = create :active_user
  end

  it 'it renders 2 Factlinks' do
    # user create a factlink
    factlink = backend_create_fact

    # user2 interact with user's factlink
    factlink.add_opiniated :believes, @user2.graph_user

    # user2 follow user
    Pavlov.old_interactor :'users/follow_user', @user2.username, @user.username, current_user: @user2

    # user2 post to topic
    other_channel = backend_create_channel_of_user @user2
    backend_add_fact_to_channel factlink, other_channel

    visit channel_activities_path(@user, @user.graph_user.stream)

    assume_unchanged_screenshot 'feed'
  end
end
