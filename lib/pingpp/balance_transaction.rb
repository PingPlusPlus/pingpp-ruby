module Pingpp
  class BalanceTransaction < AppBasedResource
    extend Pingpp::APIOperations::List

    def self.object_name
      'balance_transaction'
    end
  end
end
