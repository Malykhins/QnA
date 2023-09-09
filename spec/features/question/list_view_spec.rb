# frozen_string_literal: true
require 'rails_helper'

feature 'The user can view a list of questions' do
  scenario 'User visits a page with a list of questions' do
    questions = create_list(:question, 3)

    visit questions_path

    questions.each do |question|
      expect(page).to have_content(question.title)
    end
  end
end
