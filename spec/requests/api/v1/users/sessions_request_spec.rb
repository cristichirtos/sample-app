# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Users::SessionsController do
  describe 'POST /api/v1/users/sessions' do
    subject(:perform_request) { post '/api/v1/users/sessions', params: params.to_json, headers: common_headers }

    let(:user) { create(:user, password: 'password123!') }
    let(:password) { 'password123!' }
    let(:params) do
      {
        user: {
          email: user.email,
          password:
        }
      }
    end

    context 'when params are valid' do
      let(:tokens) { auth_tokens }
      let(:expected_response) do
        UserSerializer.new(user, with_auth_tokens: true).to_json
      end

      before do
        allow_any_instance_of(User).to receive(:tokens).and_return(tokens)
      end

      it 'responds with user info and auth tokens' do
        perform_request

        expect(response).to have_http_status(:ok)
        expect(response.body).to eq(expected_response)
      end
    end

    context 'when params are not valid' do
      let(:password) { 'invalid-password' }

      it 'returns an error' do
        perform_request

        expect(response).to have_http_status(:unauthorized)
        expect(json[:message]).to eq(I18n.t('devise.failure.invalid', authentication_keys: :email))
      end
    end
  end

  describe 'DELETE /api/v1/sessions' do
    subject(:perform_request) { delete '/api/v1/users/sessions', headers: { **common_headers, **auth_headers(token.token) } }

    let(:user) { create(:user) }
    let(:token) { create(:oauth_access_token, resource_owner_id: user.id) }

    context 'when token is valid' do
      it 'revokes access token' do
        expect { perform_request }.to change { token.reload.revoked_at }.from(nil)

        expect(response).to have_http_status(:ok)
      end
    end

    context 'when token is invalid' do
      let(:token) { instance_double(Doorkeeper::AccessToken, token: 'invalid-token') }

      it 'responds with 401' do
        perform_request

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
