# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  subject(:user) { build(:user) }

  it 'has a valid factory' do
    expect(user).to be_valid
  end

  describe 'ActiveRecord validations' do
    it { is_expected.to validate_presence_of(:email) }

    context 'with invalid password complexity' do
      it { is_expected.not_to allow_value('short').for(:password) }
      it { is_expected.not_to allow_value('longerpassword').for(:password) }
    end

    context 'with valid password complexity' do
      it { is_expected.to allow_value('p@ssword123').for(:password) }
      it { is_expected.to allow_value('p4ssword!').for(:password) }
    end
  end

  describe '.authenticate' do
    subject { described_class.authenticate(email:, password:) }

    let(:email) { 'test_user1@example.com' }
    let(:user_password) { 'password1!' }
    let(:password) { user_password }

    context 'when user exists' do
      let!(:user) { create(:user, email:, password: user_password, password_confirmation: user_password) }

      context 'with valid password' do
        it { is_expected.to eq(user) }
      end

      context 'with invalid password' do
        let(:password) { 'invalid-password' }

        it { is_expected.to be_nil }
      end
    end

    context 'when user does not exist' do
      it { is_expected.to be_nil }
    end
  end

  describe '.confirm_by_token!' do
    subject(:confirm) { described_class.confirm_by_token!(confirmation_token:) }

    let(:confirmation_token) { 'valid_confirmation_token' }

    context 'when user exists' do
      let!(:user) { create(:user, confirmation_token:, confirmed_at: nil) }

      it 'confirms the user' do
        expect { confirm }.to change { user.reload.confirmed_at }.from(nil)
      end

      it 'clears the confirmation token' do
        expect { confirm }.to change { user.reload.confirmation_token }.from(confirmation_token).to(nil)
      end
    end

    context 'when user does not exist' do
      it 'raises a ValidationFailed error' do
        expect { confirm }.to raise_error(ValidationFailed, I18n.t('errors.auth.invalid_link'))
      end
    end
  end
end
