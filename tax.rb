require 'delegate'
require_relative 'lib/tax_code'

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

  class Adjustable < ::SimpleDelegator
    def initialize(delegate, adjustment: 0)
      super delegate
      @adjustment = adjustment
    end

    def value
      super + @adjustment
    end
  end

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
