module TaxCode
  module Value
    class PercentBracketable < ::SimpleDelegator
      def initialize(delegate, from:, to:, percentage:)
        super Percentable.new(
          Bracketable.new(delegate, from: from, to: to),
          percentage: percentage
        )
      end
    end
  end
end
