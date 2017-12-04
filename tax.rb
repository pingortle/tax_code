require 'delegate'
require_relative 'lib/tax_code'

module Value
  class PercentBracketable < ::SimpleDelegator
    include TaxCode::Value

    def initialize(delegate, from:, to:, percentage:)
      super Percentable.new(
        Bracketable.new(delegate, from: from, to: to),
        percentage: percentage
      )
    end
  end
end

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
