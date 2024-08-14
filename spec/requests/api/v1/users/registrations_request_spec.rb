# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Users::RegistrationsController do
  describe 'POST /api/v1/users/registrations' do
    subject(:create_registration_request) { post '/api/v1/users/registrations', params: params.to_json, headers: common_headers }

    let(:params) do
      {
        user: {
          email:,
          password: 'Password123!',
          password_confirmation: 'Password123!'
        }
      }
    end

    context 'when params are valid' do
      let(:email) { 'test@test.com' }

      it 'creates a User' do
        expect { create_registration_request }.to change(User, :count).by(1)
      end

      it 'returns the User without tokens' do
        create_registration_request

        expect(response).to have_http_status(:created)
        expect(json).to include('id', 'email')
        expect(json).not_to include('tokens')
      end
    end

    context 'when params are not valid' do
      let(:email) { 'email' }

      it 'returns the error message' do
        create_registration_request

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json[:errors]).to eq(['Email is invalid'])
      end
    end
  end
end
