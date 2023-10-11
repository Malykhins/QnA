require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
} do
  given!(:user) { create :user }
  given!(:question) { create :question }
  given!(:answer) { create :answer, user: user, question: question }

  scenario 'Unauthenticated user can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do
    before { sign_in(user) }

    background do
      file = Rails.root.join('spec', 'fixtures', 'files', 'file1.txt')
      answer.files.attach(io: File.open(file), filename: 'file1.txt')

      visit question_path(question)
      click_on 'Edit'
    end

    scenario 'edit his answer' do
      within '.answers' do
        fill_in 'Your answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edit his answer with attachments' do
      within '.answers' do
        fill_in 'Your answer', with: 'edited text of answer'

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
