# frozen_string_literal: true

Rails.application.config.generators do |g|
  # Disable generators we don't need.
  g.assets false
  g.helper false
end
