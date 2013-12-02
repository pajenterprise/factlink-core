require 'screenshot_helper'

describe "Non signed in pages:", type: :feature do
  include Acceptance::ChannelHelper
  include Screenshots::DiscussionHelper

  describe "Profile page page" do
    it "renders correctly" do
      @user = sign_in_user create :full_user

      factlink = backend_create_fact
      channel = backend_create_channel_of_user @user
      backend_add_fact_to_channel factlink, channel

      sign_out_user
      visit user_path(@user)

      assume_unchanged_screenshot "non_signed_in_profile"
    end
  end
end
