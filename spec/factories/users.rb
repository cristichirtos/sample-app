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
FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password { Faker::Internet.password(min_length: 8, special_characters: true) + rand(0..9).to_s }
    confirmed_at { 1.month.ago }
  end

  trait :unconfirmed do
    confirmed_at { nil }
  end
end
