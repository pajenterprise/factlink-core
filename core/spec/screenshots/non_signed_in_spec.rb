require 'acceptance_helper'

describe "Non signed in pages:", type: :feature do
  include ScreenshotTest
  include Acceptance::FactHelper

  describe "Profile page page" do
    it "renders correctly" do
      @user = sign_in_user create :user

      factlink = create :fact

      sign_out_user
      visit user_path(@user)

      assume_unchanged_screenshot "non_signed_in_profile"
    end
  end
end
