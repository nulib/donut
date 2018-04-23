require 'ldp'

module Donut
  module Retry
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
  end
end

Donut::Retry.configure(Donut::Retry::Ldp)
