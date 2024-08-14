# frozen_string_literal: true

Doorkeeper.configure do
  orm :active_record

  resource_owner_authenticator do
    User.authenticate(email: params[:email], password: params[:password])
  end

  access_token_expires_in 2.hours

  use_refresh_token
end
