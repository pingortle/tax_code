require 'delegate'

module TaxCode
  autoload :TaxYear, 'tax_code/tax_year'

  module Value
    autoload :Adjustable, 'tax_code/value/adjustable'
    autoload :Basic, 'tax_code/value/basic'
    autoload :Bracketable, 'tax_code/value/bracketable'
    autoload :Percentable, 'tax_code/value/percentable'
    autoload :PercentBracketable, 'tax_code/value/percent_bracketable'
  end
end
