require 'rails_helper'

feature 'User removes a link from an answer', %q{
  In order to remove additional information from my answer
  As an authenticated user
  I'd like to be able to delete link
} do

  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, :with_link, user: author, question: question) }

  describe 'The user is the author of the answer', js: true do
    background do
      sign_in(author)
      visit question_path(question)
    end

    scenario 'Try to remove a link in an answer' do
      within('.answers') do
        click_on 'Delete'


        expect(page).to have_no_link 'Yandex'
      end
    end
  end

  describe 'User as not an author', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'Try to remove a link in an answer' do

      within('.answers') do
        expect(page).to have_no_link 'Delete'
      end
    end
  end

end
