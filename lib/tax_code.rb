require 'delegate'

module TaxCode
  module Value
    autoload :Adjustable, 'tax_code/value/adjustable'
    autoload :Basic, 'tax_code/value/basic'
    autoload :Bracketable, 'tax_code/value/bracketable'
    autoload :Percentable, 'tax_code/value/percentable'
  end
end
