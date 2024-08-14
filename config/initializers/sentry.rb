# frozen_string_literal: true

return if ENV['CI'].present?

unless Rails.env.in?(%w[development test])
  Sentry.init do |config|
    config.dsn = 'REPLACE_THIS_WITH_CREDENTIAL'
    config.breadcrumbs_logger = %i[active_support_logger http_logger]

    config.traces_sample_rate = 1.0

    config.environment = Rails.env
  end
end
