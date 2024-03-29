require 'rails_helper'
require Rails.root.join 'spec/concerns/voted_spec.rb'

RSpec.describe AnswersController, type: :controller do
  it_behaves_like 'voted'
  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer in data base' do
        expect {
          post :create, params: { answer: attributes_for(:answer), question_id: question },
                        format: :js
        }.to change(question.answers, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect {
          post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question },
                        format: :js
        }.to_not change(Answer, :count)
      end

      it 'redirects to show view' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question, format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }

    context 'the user is the author of the answer' do
      let!(:answer) { create(:answer, question: question, user: user) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'redirects to show question' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'the user is not the author of the answer' do
      let!(:answer) { create(:answer, question: question) }

      it 'does not delete the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.not_to change(Answer, :count)
      end

      it 'returns a 403 Forbidden status' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to have_http_status(403)
      end
    end
  end

  describe 'EDIT #update' do
    before { login(user) }
    let!(:answer) { create(:answer, question: question, user: user) }

    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to eq('new body')
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: { body: 'new body' }, format: :js }
        expect(response).to render_template :update
      end

      it 'removes the attached files from the answer' do
        file = fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'file1.txt'), 'text/plain')

        answer.files.attach(file)

        patch :update, params: { id: answer.id, answer: { remove_files: [answer.files.first.id] } }, format: :js

        answer.reload
        expect(answer.files).to be_empty
      end
    end

    context 'with invalid attributes' do
      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end

      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        end.to_not change(answer, :body)
      end
    end
  end

  describe 'SET_BEST #update' do
    before { login(user) }
    let(:answer) { create(:answer, question: question, user: user) }

    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :set_best, params: { id: answer, answer: { best: true } }, format: :js
        answer.reload
        expect(answer.best).to eq(true)
      end

      it 'renders update view' do
        patch :set_best, params: { id: answer, answer: { best: true }, format: :js }
        expect(response).to render_template :set_best
      end
    end
  end
end
