module TaxCode
  module Value
    class Percentable < ::SimpleDelegator
      def initialize(delegate, percentage:)
        super delegate
        @percentage = percentage
      end

      attr_reader :percentage

      def value
        super * percentage * 0.01
      end
    end
  end
end
