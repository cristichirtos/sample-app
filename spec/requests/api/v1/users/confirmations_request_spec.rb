# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Users::ConfirmationsController do
  describe 'POST /api/v1/users/confirmations' do
    subject(:perform_request) { post '/api/v1/users/confirmations', params: params.to_json, headers: common_headers }

    let(:user) { create(:user, confirmed_at: nil) }
    let(:params) { { confirmation_token: } }
    let(:confirmation_token) do
      user.send(:generate_confirmation_token!)
      user.confirmation_token
    end

    context 'when confirmation token is invalid' do
      let(:confirmation_token) { 'token' }

      it 'returns an error message' do
        perform_request

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json[:message]).to eq(I18n.t('errors.auth.invalid_link'))
      end
    end

    context 'when confirmation token is valid' do
      it 'confirms the user' do
        perform_request

        expect(user.reload.confirmed_at).not_to be_nil
      end

      it 'returns a success response' do
        perform_request

        expect(response).to have_http_status(:ok)
      end
    end
  end
end
