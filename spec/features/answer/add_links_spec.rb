require 'rails_helper'

feature 'User add links to answer', %q{
  In order to provide additional info to my answer
  As an answers author
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:gist_url) { 'https://gist.github.com/Malykhins/6a55c9211ea02ee4929ea62f6dbc7c7c' }
  given(:invalid_url) { 'ya.ru' }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)

      fill_in 'Body', with: 'Text of answer'
    end

    scenario 'User adds valid link when give an answer' do
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url

      click_on 'Create Answer'

      expect(page).to have_link 'My gist', href: gist_url
    end

    scenario 'User adds invalid link when give an answer' do
      fill_in 'Link name', with: 'yandex'
      fill_in 'Url', with: invalid_url

      click_on 'Create Answer'

      expect(page).to have_content 'is not a valid URL'
    end
  end
end
