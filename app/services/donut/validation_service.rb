module Donut
  class ValidationService
    attr_reader :trashable_instance
    delegate :valid?, :errors, to: :trashable_instance

    class << self
      def errors(klass:, attributes:)
        new(klass: klass, attributes: attributes).errors
      end

      def valid?(klass:, attributes:)
        new(klass: klass, attributes: attributes).valid?
      end
    end

    def initialize(klass:, attributes:)
      @trashable_instance = klass.new(attributes).tap { |t| t.valid? }
    end
  end
end
