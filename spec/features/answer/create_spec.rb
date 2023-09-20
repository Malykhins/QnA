# frozen_string_literal: true

require 'rails_helper'

feature 'User can create answer', "
  In order to answer the question
  As an authenticated user
  I'd like to be able to answer the question
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    before { sign_in(user) }

    background do
      create(:answer, question: question, user: user)
      visit question_path(question)
    end

    scenario 'Answer the question' do
      fill_in 'Body', with: 'Text of answer'
      click_on 'Create Answer'

      expect(current_path).to eq(question_path(question))
      expect(page).to have_content 'Your answer successfully created!'

      expect(page).to have_content 'Text of answer'
    end

    scenario 'Answer the question with errors' do
      click_on 'Create Answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to answer the question' do
    visit question_path(question)
    click_on 'Create Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
