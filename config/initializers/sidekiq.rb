# frozen_string_literal: true

require 'sidekiq/web'
require 'sidekiq/cron/web'

return if Rails.env.test? || ENV['CI'].present?

sidekiq_username = 'sidekiq'
sidekiq_password = 'REPLACE_THIS_WITH_CREDENTIAL'

Sidekiq.strict_args!(false)

Sidekiq::Web.app_url = '/'
Sidekiq::Web.use(Rack::Auth::Basic, 'Application') do |username, password|
  username == sidekiq_username &&
    ActiveSupport::SecurityUtils.secure_compare(password, sidekiq_password)
end

Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://localhost:6379/1' }
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://localhost:6379/1' }
end
