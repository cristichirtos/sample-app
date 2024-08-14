# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  created_at             :datetime         not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  id                     :bigint           not null, primary key
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  unconfirmed_email      :string
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  PASSWORD_COMPLEXITY_REGEX = /
                                (?=.*?\w)       # At least one word character
                                (?=.*?[0-9])    # At least one digit
                                (?=.*?[#?!@$%^&*-]) # At least one special character
                              /x

  devise :database_authenticatable, :validatable, :confirmable, :recoverable

  validate :password_complexity, if: :password

  class << self
    def authenticate(email:, password:)
      user = User.find_for_authentication(email:)
      user&.valid_password?(password) ? user : nil
    end

    def confirm_by_token!(confirmation_token:)
      user = User.find_by(confirmation_token:)

      raise ValidationFailed.new(message: I18n.t('errors.auth.invalid_link'), skip_logging: true) if user.blank?

      user.confirm
      user.update!(confirmation_token: nil)
    end
  end

  def tokens
    access_token = Doorkeeper::AccessToken.create!(
      resource_owner_id: id,
      expires_in: Doorkeeper.configuration.access_token_expires_in,
      use_refresh_token: Doorkeeper.configuration.refresh_token_enabled?
    )

    Doorkeeper::OAuth::TokenResponse.new(access_token).body.with_indifferent_access
  end

  private

    def password_complexity
      return if password =~ PASSWORD_COMPLEXITY_REGEX

      errors.add :password, :complexity_not_met
    end
end
