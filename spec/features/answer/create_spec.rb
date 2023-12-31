# frozen_string_literal: true

require 'rails_helper'

feature 'User can create answer', "
  In order to answer the question
  As an authenticated user
  I'd like to be able to answer the question
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    before { sign_in(user) }

    background do
      create(:answer, question: question, user: user)

      visit question_path(question)
    end

    scenario 'Answer the question' do
      within('.new-answer-form') do
        fill_in 'Body', with: 'Text of answer'
        click_on 'Create Answer'
      end

      expect(current_path).to eq(question_path(question))
      within '.answers' do
        expect(page).to have_content 'Text of answer'
      end
    end

    scenario 'Answer the question with errors' do
      click_on 'Create Answer'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'Answer the question with attached files' do
      within('.new-answer-form') do
        fill_in 'Body', with: 'Text of answer'

        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

        click_on 'Create Answer'
      end

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario 'Unauthenticated user tries to answer the question' do
    visit question_path(question)

    expect(page).to_not have_link 'Create Answer'
  end
end
