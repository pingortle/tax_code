require 'delegate'

module Value
  class Basic < ::SimpleDelegator
    def value
      self
    end
  end

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
    raise 'gross value must be greater than or equal to zero' if gross < 0
    @gross = gross
  end

  def value
    @gross
  end
end

class Transform
  def initialize(type, *params)
    @type = type
    @params = params
  end

  def transform(valuable)
    @type.new valuable, *@params
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

class NetIncome
  def initialize(salary, pretaxes: [], taxables: [], taxes: [], adjustments: [])
    @salary = salary
    @pretaxes = pretaxes
    @taxables = taxables
    @taxes = taxes
    @adjustments = adjustments
  end

  def value
    pretax = after_deductions @salary, @pretaxes
    tax = after_taxes pretax
    net = after_deductions tax, @taxables
    net.value
  end

  def print_stats
    p '*' * 60
    p "Net income: #{value}"
    p "Net income/mo: #{value/12.0}"
    p "Net income/pp: #{value/24.0}"
    p '*' * 60
  end

  private
    def after_deductions(salary, deductions)
      total_deductions = deductions.reduce(0) do |memo, transform|
        memo + salary.value - transform.transform(salary).value
      end
      Value::Adjustable.new salary, adjustment: -total_deductions
    end

    def after_taxes(salary)
      adjusted_salary = after_deductions salary, @adjustments
      total_taxes = @taxes.map do |transform|
        transform.transform(adjusted_salary).value
      end.reduce(:+)
      Value::Adjustable.new salary, adjustment: -total_taxes
    end
end
