# frozen_string_literal: true

require 'rails_helper'

feature 'User can delete answer', "
  In order to delete the answer
  As an authenticated user
  I'd like to be able to delete my answer
" do
  given(:author) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: author) }

  describe 'User is the author of the answer' do
    background do
      sign_in(author)
      visit question_path(question)
    end

    scenario 'try to delete the answer', js: true do
      click_on 'Delete Answer'

      expect(page).to_not have_content answer.body
      expect(page).to have_no_content 'Delete Answer'
    end
  end

  describe 'User as not an author' do
    let(:user) { create(:user) }

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'try to delete the answer', js: true do
      expect(page).to have_no_content 'Delete Answer'
    end
  end
end
