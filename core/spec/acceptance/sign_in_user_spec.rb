require 'acceptance_helper'

describe 'When a user signs in', type: :feature do
  it 'and has not yet confirmed his email address it should fail' do
    user = create :user

    sign_in_user(user)

    page.should have_content "Your account has not yet been approved"
  end

  it 'he should be able to sign out' do
    user = create :full_user

    sign_in_user(user)

    page.should_not have_content "Your login credentials were incorrect. Please check and try again"

    visit '/users/sign_out'

    visit '/'

    first(:link, "Sign in", exact: true).click

    find "div.sign_in_bar"
  end

  it 'he should not be able to sign in with false credentials' do
    user = create :full_user

    visit "/"

    first(:link, "Sign in", exact: true).click

    fill_in "user_login", :with => user.email
    fill_in "user_password", :with => user.password + "1"
    click_button "Sign in"

    page.should have_content "Your login credentials were incorrect. Please check and try again"
  end
end
