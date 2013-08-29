require 'screenshot_helper'

describe "factlink", type: :feature do
  include Screenshots::DiscussionHelper

  before :each do
    @user = sign_in_user create :active_user
  end

  it "the layout of the discussion page is correct" do
    @factlink = create_discussion

    go_to_discussion_page_of @factlink

    find('.evidence-item', text: 'Fact 1').find('a', text:'1 comment')

    page.should have_content @factlink.data.displaystring

    assume_unchanged_screenshot "discussion_page"
  end
end
