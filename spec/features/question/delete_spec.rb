# frozen_string_literal: true

require 'rails_helper'

feature 'User can delete question', "
  In order to delete the question
  As an authenticated user
  I'd like to be able to delete my question
" do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: author) }

  describe 'User is the author of the question' do
    background do
      sign_in(author)
      visit question_path(question)
    end

    scenario 'try to delete the answer' do
      click_on 'Delete Question'

      expect(page).to have_content 'Your question successfully deleted.'
    end
  end

  describe 'User as not an author' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'try to delete the answer' do
      expect(page).to have_no_content 'Delete Question'
    end
  end
end
