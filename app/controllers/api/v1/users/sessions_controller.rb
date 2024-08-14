# frozen_string_literal: true

module Api
  module V1
    module Users
      class SessionsController < BaseController
        skip_before_action :doorkeeper_authorize!, only: :create

        def create
          user = User.authenticate(email: user_sign_in_params[:email], password: user_sign_in_params[:password])

          return render_error_message(message: I18n.t('devise.failure.invalid', authentication_keys: :email), code: :unauthorized) unless user

          if user.active_for_authentication?
            render json: user, with_auth_tokens: true, status: :ok
          else
            render_error_message(message: I18n.t('devise.failure.unconfirmed'), code: :forbidden)
          end
        end

        def destroy
          doorkeeper_token.revoke

          head :ok
        end

        private

          def user_sign_in_params
            params.require(:user).permit(:email, :password)
          end
      end
    end
  end
end
