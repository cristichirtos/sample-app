# frozen_string_literal: true

Sidekiq::Web.use ActionDispatch::Cookies
Sidekiq::Web.use ActionDispatch::Session::CookieStore, key: '_interslice_session'

Rails.application.routes.draw do
  use_doorkeeper scope: 'api/v1/sessions' do
    skip_controllers :authorizations, :applications, :authorized_applications
    controllers tokens: 'api/v1/oauth_tokens'
  end

  mount Sidekiq::Web => '/sidekiq' # monitoring console

  namespace :api do
    namespace :v1 do
      devise_for :users,
                 path_names: { password: 'password_resets', confirmation: 'confirmations' },
                 controllers: { passwords: 'api/v1/users/password_resets', confirmations: 'api/v1/users/confirmations' }

      namespace :users do
        resource :registrations, only: :create
        resource :sessions, only: %i[create destroy]
        resource :passwords, only: :update
      end
    end
  end
end
