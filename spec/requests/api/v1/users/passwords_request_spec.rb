# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Users::PasswordsController do
  let(:user) { create(:user, password: 'password1!') }

  describe 'PATCH /api/v1/users/passwords' do
    subject(:perform_request) { patch '/api/v1/users/passwords', params: params.to_json, headers: common_headers }

    before { stub_current_user(user) }

    context 'when current password is not valid' do
      let(:params) { { password: 'fake-password' } }
      let(:expected_error) { { message: 'Current password is invalid' } }

      it_behaves_like 'invalid password change attempt'
    end

    context 'when new password is not valid' do
      let(:params) { { password: 'password1!', new_password: 'parola123', new_password_confirmation: 'parola123' } }
      let(:expected_error) { { errors: ['Password must contain at least 8 characters, a digit and a special character'] } }

      it_behaves_like 'invalid password change attempt'
    end

    context 'when new password is valid' do
      let(:params) { { password: 'password1!', new_password: 'parola123!', new_password_confirmation: 'parola123!' } }

      it 'updates the user password' do
        expect { perform_request }.to(change { user.reload.encrypted_password })
      end

      it 'returns a success response' do
        perform_request

        expect(response).to have_http_status(:ok)
      end
    end
  end
end
