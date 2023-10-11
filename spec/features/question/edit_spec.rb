require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like to be able to edit my question
} do
  given!(:user) { create :user }
  given!(:question) { create :question, user: user }

  scenario 'Unauthenticated user can not edit question' do
    visit questions_path

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do
    background do
      file = Rails.root.join('spec', 'fixtures', 'files', 'file1.txt')
      question.files.attach(io: File.open(file), filename: 'file1.txt')

      sign_in(user)
      visit questions_path

      click_on 'Edit'
    end

    scenario 'edit his question' do
      within '.questions' do
        fill_in 'Title', with: 'edited title'
        click_on 'Save'

        expect(page).to_not have_content question.body
        expect(page).to have_content 'edited title'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edit his question with attachments' do
      within '.questions' do
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

        click_on 'Save'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'removes files from their own question' do
      find('input[type="checkbox"]').click

      click_button 'Save'

      expect(page).to_not have_link 'file1.txt'
    end
  end
end
