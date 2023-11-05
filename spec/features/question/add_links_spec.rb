require 'rails_helper'

feature 'User add links to question', %q{
  In order to provide additional info to my question
  As an questions author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/Malykhins/6a55c9211ea02ee4929ea62f6dbc7c7c' }
  given(:invalid_url) { 'ya.ru' }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit new_question_path

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
    end

    scenario 'User adds valid link when asks question' do
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url

      click_on 'Ask'

      expect(page).to have_link 'My gist', href: gist_url
    end

    scenario 'User adds invalid link when asks question' do
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: invalid_url

      click_on 'Ask'

      expect(page).to have_content 'is not a valid URL'
    end
  end
end
