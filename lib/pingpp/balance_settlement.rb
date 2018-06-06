module Pingpp
  class BalanceSettlement < AppBasedResource
    extend Pingpp::APIOperations::List

    def self.object_name
      'balance_settlement'
    end
  end
end
