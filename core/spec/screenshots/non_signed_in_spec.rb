require 'acceptance_helper'

describe "Non signed in pages:", type: :feature do
  include ScreenshotTest
  include Acceptance::FactHelper

  describe "Profile page page" do
    it "renders correctly" do
      user = sign_in_user create :user

      fact_data = create :fact_data, displaystring: 'Throngs of them!!1!'
      as(user) do |pavlov|
        pavlov.interactor(:'comments/create',
                           fact_id: fact_data.fact_id,
                           content: 'content')
      end
      sign_out_user
      visit user_profile_path(user)
      assume_unchanged_screenshot "non_signed_in_profile"
    end
  end
end
