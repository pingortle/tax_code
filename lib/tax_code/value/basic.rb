module TaxCode
  module Value
    class Basic < ::SimpleDelegator
      def value
        self
      end
    end
  end
end
