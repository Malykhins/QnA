require 'rails_helper'

feature 'User add links to answer', %q{
  In order to provide additional info to my answer
  As an answers author
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:valid_url) { 'https://google.com' }
  given(:invalid_url) { 'ya.ru' }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)

      fill_in 'Body', with: 'Text of answer'
    end

    scenario 'User adds valid link when give an answer' do
      fill_in 'Link name', with: 'Google'
      fill_in 'Url', with: valid_url

      click_on 'Create Answer'

      expect(page).to have_link 'Google', href: valid_url
    end

    scenario 'User adds invalid link when give an answer' do
      fill_in 'Link name', with: 'yandex'
      fill_in 'Url', with: invalid_url

      click_on 'Create Answer'

      expect(page).to have_content 'is not a valid URL'
    end
  end
end
