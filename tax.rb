require 'delegate'
require_relative 'lib/tax_code'

class Salary
  def initialize(gross: 0)
    raise ArgumentError, 'gross value must be greater than or equal to zero' if gross < 0
    @gross = gross
  end

  def value
    @gross
  end
end

class TaxYear
  include TaxCode

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
