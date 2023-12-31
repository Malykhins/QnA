require 'rails_helper'

feature 'User can create question', %q{
  In order to getanswer from a community
  As an authenticated user
  I'd like to be able to ask the question
} do
  given(:user) { create(:user) }
  given(:reward) { create(:reward) }

  describe 'Authenticated user' do
    before { sign_in(user) }

    background do
      visit questions_path
      click_on 'Ask question'
    end

    scenario 'Ask a question' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'text text text'
    end
    scenario 'Ask a question with errors' do
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end

    scenario 'asks a question with attached files' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Ask'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'asks a question with reward' do
      fill_in 'Title', with: 'Test question with reward'
      fill_in 'Body', with: 'text text text'

      within('.reward') do
        fill_in 'Reward name', with: 'Cup'
        attach_file 'Image', "#{Rails.root}/spec/fixtures/files/cup.png"
      end

      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content 'Cup'
    end

  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit questions_path

    expect(page).to_not have_link 'Ask question'
  end
end
