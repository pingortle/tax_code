module TaxCode
  class Salary
    def initialize(gross: 0)
      raise ArgumentError, 'gross value must be greater than or equal to zero' if gross < 0
      @gross = gross
    end

    def value
      @gross
    end
  end
end
