# frozen_string_literal: true

module Api
  module V1
    module Users
      class PasswordsController < BaseController
        before_action :check_password_valid

        def update
          current_user.update!(password: params[:new_password], password_confirmation: params[:new_password_confirmation])

          head :ok
        end

        private

          def check_password_valid
            return if current_user.valid_password?(params[:password])

            render_error_message(message: I18n.t('errors.invalid_password'))
          end
      end
    end
  end
end
