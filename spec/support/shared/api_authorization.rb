shared_examples_for 'API Authorizable' do
  context 'unauthorized' do
    it 'returns 401 status if there is no access token' do
      do_request method, api_url, params: { format: :json }
      expect(response.status).to eq 401
    end

    it 'returns 401 status if access_token is invalid' do
      do_request method, api_url, params: { format: :json, access_token: '1234' }
      expect(response.status).to eq 401
    end
  end
end

shared_examples_for 'API Validatable' do
  context 'with invalid attributes' do
    before { do_request method, api_url, params: invalid_params }

    it 'returns 422 status' do
      expect(response.status).to eq 422
    end

    it 'returns a validation failure message' do
      expect(json['errors']['body']).to match(["can't be blank"])
    end
  end
end
