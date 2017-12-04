module Pingpp
  class RoyaltyTransaction < APIResource
    extend Pingpp::APIOperations::List

    def self.object_name
      'royalty_transaction'
    end
  end
end
