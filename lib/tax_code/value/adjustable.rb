module TaxCode
  module Value
    class Adjustable < ::SimpleDelegator
      def initialize(delegate, adjustment: 0)
        super delegate
        @adjustment = adjustment
      end

      def value
        super + @adjustment
      end
    end
  end
end
