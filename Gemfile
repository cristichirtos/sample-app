# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.1'

# Auth
gem 'devise', '~> 4.9.3'
gem 'doorkeeper', '~> 5.6.9'

# Core
gem 'bootsnap', '~> 1.18.3'
gem 'sprockets', '< 4'
gem 'pg', '~> 1.5.6'
gem 'puma', '~> 6.4.2'
gem 'rack-cors', '~> 2.0.2'
gem 'rails', '~> 7.1.3.2'
gem 'sassc-rails', '~> 2.1.2'
gem 'sidekiq', '~> 7.2.2'
gem 'sidekiq-cron', '~> 1.12.0'
gem 'redis', '~> 5.1.0'

# Configuration
gem 'dotenv-rails'

# Serialization
gem 'active_model_serializers', '~> 0.10.14'

# Logging
gem 'sentry-ruby', '~> 5.16.1'
gem 'sentry-rails', '~> 5.16.1'

# Network
gem 'faraday', '~> 2.9.0'
gem 'uri', '~> 0.13.0'

# Misc
gem 'haml-rails', '~> 2.1.0'

group :development do
  gem 'annotate', '~> 3.2.0'
  gem 'better_errors', '~> 2.9', '>= 2.9.1'
  gem 'brakeman', '~> 6.1.2', require: false
  gem 'bundler-audit', '~> 0.9.1', require: false
  gem 'letter_opener', '~> 1.9'
  gem 'overcommit', '~> 0.63.0', require: false
  gem 'rubocop', '~> 1.62.0', require: false
  gem 'rubocop-rspec', '~> 2.27.1', require: false
end

group :development, :test do
  gem 'byebug', '~> 11.1.3'
  gem 'factory_bot_rails', '~> 6.4.3'
  gem 'faker', '~> 3.2.3'
  gem 'rspec-rails', '~> 6.1.1'
  gem 'shoulda-matchers', '~> 4.5.1'
  gem 'vcr', '~> 6.2.0'
  gem 'webmock', '~> 3.23.0'
end

group :test do
  gem 'shoulda', '~> 4.0'
end
