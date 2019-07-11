module Pingpp
  class ProfitTransaction < APIResource
    extend Pingpp::APIOperations::List

    def self.object_name
      'profit_transaction'
    end

    def self.resource_url(opts={})
      '/v1/profit_transactions'
    end

  end
end
