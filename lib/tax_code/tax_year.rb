module TaxCode
  class TaxYear
    def initialize(salary, bracket_data)
      @salary = salary
      @bracket_data = bracket_data
    end

    def value
      bracketed_taxes.map(&:value).reduce(:+)
    end

    private
      def bracketed_taxes
        @bracket_data.map do |data|
          Value::PercentBracketable.new @salary, data
        end
      end
  end
end
