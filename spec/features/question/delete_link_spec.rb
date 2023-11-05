require 'rails_helper'

feature 'User removes a link from a question', %q{
  In order to remove additional information from my question
  As an authenticated user
  I'd like to be able to delete link
} do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, :with_link, user: author) }

  describe 'The user is the author of the question', js: true do
    background do
      sign_in(author)
      visit questions_path

      click_on 'Show'

    end

    scenario 'Try to remove a link in a question', js: true do
      sleep 1
      click_on 'Delete'

      expect(page).to have_no_link 'Yandex'
    end
  end

  describe 'User as not an author', js: true do
    background do
      sign_in(user)
      visit questions_path

      click_on 'Show'

    end

    scenario 'Try to remove a link in an question', js: true do
      expect(page).to have_no_link 'Delete'
    end
  end
end
