module Pingpp
  class BalanceTransfer < AppBasedResource
    extend Pingpp::APIOperations::List
    extend Pingpp::APIOperations::Create

    def self.object_name
      'balance_transfer'
    end
  end
end
