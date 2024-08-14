# frozen_string_literal: true

module Api
  module V1
    module Users
      class ConfirmationsController < BaseController
        skip_before_action :doorkeeper_authorize!

        def create
          User.confirm_by_token!(confirmation_token: params[:confirmation_token])

          head :ok
        end
      end
    end
  end
end
