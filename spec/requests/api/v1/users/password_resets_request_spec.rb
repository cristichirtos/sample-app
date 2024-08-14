# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Users::PasswordResetsController do
  let(:user) { create(:user) }

  describe 'POST /api/v1/users/password_resets' do
    subject(:perform_request) { post '/api/v1/users/password_resets', params: { email: }.to_json, headers: common_headers }

    context 'when email is associated to a user' do
      let(:email) { user.email }

      it 'calls the #send_reset_password_instructions Devise method' do
        expect_any_instance_of(User).to receive(:send_reset_password_instructions)

        perform_request
      end

      it 'returns a success response' do
        perform_request

        expect(response).to have_http_status(:ok)
      end
    end

    context 'when email is not associated to a user' do
      let(:email) { "not_#{user.email}" }

      it 'does not call the #send_reset_password_instructions Devise method' do
        expect_any_instance_of(User).not_to receive(:send_reset_password_instructions)

        perform_request
      end

      it 'returns a success response' do
        perform_request

        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'PATCH /api/v1/users/password_resets' do
    subject(:perform_request) { patch '/api/v1/users/password_resets', params: params.to_json, headers: common_headers }

    let(:params) { { reset_password_token:, password:, password_confirmation: } }
    let(:reset_password_token) { user.send(:set_reset_password_token) }
    let(:password) { 'Password123!' }
    let(:password_confirmation) { 'Password123!' }

    context 'when password reset token is invalid' do
      let(:reset_password_token) { 'token' }
      let(:expected_error) { { message: I18n.t('errors.auth.invalid_link') } }

      it_behaves_like 'invalid password change attempt'
    end

    context 'when passwords do not match' do
      let(:password) { 'password123!' }
      let(:expected_error) { { errors: ['Password confirmation doesn\'t match Password'] } }

      it_behaves_like 'invalid password change attempt'
    end

    context 'when password is too simple' do
      let(:password) { 'password' }
      let(:password_confirmation) { 'password' }
      let(:expected_error) { { errors: ['Password must contain at least 8 characters, a digit and a special character'] } }

      it_behaves_like 'invalid password change attempt'
    end

    context 'when password reset token is expired' do
      let(:params) { { reset_password_token:, password: 'Password123!', password_confirmation: 'Password123!' } }
      let(:expected_error) { { message: I18n.t('errors.auth.invalid_link') } }

      before { allow_any_instance_of(User).to receive(:reset_password_period_valid?).and_return(false) }

      it_behaves_like 'invalid password change attempt'
    end

    context 'when params are valid' do
      let(:params) { { reset_password_token:, password: 'Password123!', password_confirmation: 'Password123!' } }

      it 'changes user password' do
        expect { perform_request }.to(change { user.reload.encrypted_password })
      end

      it 'responds with status code 200' do
        perform_request

        expect(response).to have_http_status(:ok)
      end
    end
  end
end
