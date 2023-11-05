require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:user) { create(:user) }

  describe 'DELETE #destroy' do
    before { login(user) }

    context 'author of resource tries to delete link' do
      let!(:question) { create(:question, :with_link, user: user) }

      it 'deletes link' do
        expect { delete :destroy, params: { id: question.links[0] }, format: :js }.to change(question.links, :count).by(-1)
      end

      it 'render destroy template' do
        delete :destroy, params: { id: question.links[0] }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context "user tries to delete other user's link" do
      let!(:other_question) { create(:question, :with_link) }

      it 'does not delete link' do
        expect { delete :destroy, params: { id: other_question.links[0] }, format: :js }.to change(other_question.links, :count).by(0)
      end
    end
  end
end