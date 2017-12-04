module TaxCode
  module Value
    class Bracketable < ::SimpleDelegator
      def initialize(delegate, from: 0, to:)
        raise ArgumentError, 'from must be less than to' if from >= to
        raise ArgumentError, 'all values must be greater than or equal to zero' if from < 0 or to < 0
        super delegate
        @from = from
        @to = to
      end

      attr_reader :to, :from

      def value
        [
          [super - from, to - from].min, 0
        ].max
      end
    end
  end
end
