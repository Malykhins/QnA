# frozen_string_literal: true

require 'rails_helper'

feature 'User can mark the answer as best', "
  In order to find the best answer
  As an authenticated user
  I would like to be able to mark the best answer to my question from the whole list
" do
  given(:author) { create(:user) }
  given(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, question: question) }

  describe 'User is the author of the question' do
    background do
      sign_in(author)
      visit question_path(question)
    end

    scenario 'try to mark the answer as best', js: true do
      within ".answers .best-answer#best-answer-#{answer.id}" do
        find('input[type="checkbox"]').click
      end

      within(".answers .best-answer#best-answer-#{answer.id}") do
        expect(page).to have_checked_field
      end
      expect(page).to have_content 'The best answer is called!'
    end
  end

  describe 'User as not an author' do
    given(:user) { create(:user) }

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'try to mark the answer as best', js: true do
      expect(page).to_not have_selector(".answers input[type='checkbox']")
    end
  end
end
