# frozen_string_literal: true

require 'rails_helper'

feature 'User can sign out', "
  As a logged-in user
  I want to be able to logout from the system
  So that my session is terminated
" do
  given(:user) { create(:user) }

  scenario "User signs out successfully" do
    sign_in user
    visit root_path
    click_on "Sign out"

    expect(page).to have_content("Signed out successfully.")
  end
end