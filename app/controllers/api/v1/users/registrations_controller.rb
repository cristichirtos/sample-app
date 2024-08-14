# frozen_string_literal: true

module Api
  module V1
    module Users
      class RegistrationsController < BaseController
        skip_before_action :doorkeeper_authorize!

        def create
          user = User.create!(user_params)

          render json: user, status: :created
        end

        private

          def user_params
            params.require(:user).permit(:email, :password, :password_confirmation)
          end
      end
    end
  end
end
