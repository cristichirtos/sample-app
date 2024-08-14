# frozen_string_literal: true

class ValidationFailed < StandardError
  attr_reader :code, :skip_logging

  def initialize(code: :unprocessable_entity, message: 'Validation failed', skip_logging: false)
    @code = code
    @skip_logging = skip_logging

    super(message)
  end
end
