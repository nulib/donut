module Donut
  module Retry
    class << self
      def tries=(n)
        [:ldp, :solr].each { |context| Retryable.configuration.contexts[context][:tries] = n }
      end

      def log_retries(tag, retries, exception)
        return if retries.zero?
        Rails.logger.warn("#{tag}: Retry ##{retries}. Reason: #{exception.class.name}: '#{exception.message}'")
      end

      def backoff_handler
        ->(n) { (n * 0.5) + (n * rand) }
      end

      def with_retries(context)
        Retryable.with_context(context) do |retries, last_exception|
          Retry.log_retries(context.to_s.upcase, retries, last_exception)
          yield
        end
      end

      def configure(mod)
        Retryable.configure do |config|
          config.contexts[mod.name.split(/::/).last.underscore.to_sym] = {
            tries: 10,
            on: mod.errors,
            not: mod.not_errors,
            sleep: backoff_handler
          }
        end
      end
    end
  end
end

require 'donut/retry/ldp'
require 'donut/retry/solr'
