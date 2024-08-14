# frozen_string_literal: true

module Api
  module V1
    module Users
      class PasswordResetsController < BaseController
        skip_before_action :doorkeeper_authorize!

        before_action :validate_token, only: :update

        def create
          User.find_by(email: params[:email])&.send_reset_password_instructions

          head :ok
        end

        def update
          user.reset_password(reset_password_params[:password], reset_password_params[:password_confirmation])

          user.save!

          head :ok
        end

        private

          def reset_password_params
            params.permit(:reset_password_token, :password, :password_confirmation)
          end

          def validate_token
            render_error_message(message: I18n.t('errors.auth.invalid_link')) if user.nil? || !user.reset_password_period_valid?
          end

          def user
            @user ||= User.with_reset_password_token(reset_password_params[:reset_password_token])
          end
      end
    end
  end
end
