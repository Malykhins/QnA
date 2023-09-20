# frozen_string_literal: true

require 'rails_helper'

feature 'User registration', "
  In order to use the application as a registered user
  As an guest
  I'd like to be able to sign up
" do

  scenario "User can sign up successfully" do
    visit new_user_registration_path

    fill_in "Email", with: "test@example.com"
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"

    click_button "Sign up"

    expect(page).to have_content "Welcome! You have signed up successfully."
    expect(page).to have_current_path(root_path)
  end
end