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

    module Ldp
      def self.errors
        [::Ldp::Error, ::Ldp::HttpError]
      end

      def self.not_errors
        [::Ldp::NotFound, ::Ldp::Gone]
      end

      def head(*args)
        Donut::Retry.with_retries(:ldp)  { super(*args) }
      end

      def get(*args)
        Donut::Retry.with_retries(:ldp)  { super(*args) }
      end

      def delete(*args)
        Donut::Retry.with_retries(:ldp)  { super(*args) }
      end

      def post(*args)
        Donut::Retry.with_retries(:ldp)  { super(*args) }
      end

      def put(*args)
        Donut::Retry.with_retries(:ldp)  { super(*args) }
      end

      def patch(*args)
        Donut::Retry.with_retries(:ldp)  { super(*args) }
      end
    end

    module Solr
      def self.errors
        [RSolr::Error::Http]
      end

      def self.not_errors
        []
      end

      def self.included(mod)
        mod.module_eval do
          alias_method :_execute, :execute

          define_method :execute do |*args|
            Donut::Retry.with_retries(:solr) { _execute(*args) }
          end
        end
      end
    end
  end
end

Donut::Retry.configure(Donut::Retry::Ldp)
Donut::Retry.configure(Donut::Retry::Solr)
