require 'rsolr'

module Donut
  module Retry
    module Solr
      def self.errors
        [RSolr::Error::Http]
      end

      def self.not_errors
        []
      end

      def self.included(mod)
        return if mod.respond_to?(:_execute)

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

Donut::Retry.configure(Donut::Retry::Solr)
