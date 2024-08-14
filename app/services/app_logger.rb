# frozen_string_literal: true

class AppLogger
  class << self
    def info(message)
      Sentry.capture_message(message, level: :info)
    end

    def warn(message)
      Sentry.capture_message(message, level: :warning)
    end

    def error(message)
      Sentry.capture_message(message, level: :error)
    end

    def scoped_message(message, tags = {}, level = :error)
      Sentry.with_scope do |scope|
        scope.set_tags(tags)

        Sentry.capture_message(message, level:)
      end
    end
  end
end
