# frozen_string_literal: true

module ApiErrorHandleable
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do |exception|
      render json: {
        message: "#{exception.model} with id=#{exception.id} not found",
        code: 'not_found'
      }, status: :not_found
    end

    rescue_from ActiveRecord::RecordInvalid do |exception|
      render json: {
        message: 'Validation failed',
        **ValidationErrorsSerializer.new(exception.record).serialize
      }, status: :unprocessable_entity
    end

    rescue_from ActionController::ParameterMissing do |exception|
      render json: {
        message: "Parameter missing: #{exception.param}",
        code: 'param_missing'
      }, status: :unprocessable_entity
    end

    rescue_from ActiveModel::UnknownAttributeError do |error|
      render json: {
        message: error.message,
        code: :unprocessable_entity
      }, status: :unprocessable_entity
    end

    rescue_from ValidationFailed do |error|
      AppLogger.error(error.message) unless error.skip_logging

      error_message = error.message == 'ValidationFailed' ? I18n.t('errors.validation_failed') : error.message

      render json: {
        message: error_message,
        code: error.code.to_s
      }, status: error.code
    end
  end
end
