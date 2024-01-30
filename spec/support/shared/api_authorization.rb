shared_examples_for 'API Authorizable' do
  context 'unauthorized' do
    it 'returns 401 status if there is no access token' do
      get api_url, params: { format: :json }
      expect(response.status).to eq 401
    end

    it 'returns 401 status if access_token is invalid' do
      get api_url, params: { format: :json, access_token: '1234' }
      expect(response.status).to eq 401
    end
  end
end