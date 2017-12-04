module Pingpp
  class RoyaltySettlement < APIResource
    extend Pingpp::APIOperations::Create
    extend Pingpp::APIOperations::List
    include Pingpp::APIOperations::Update

    def self.object_name
      'royalty_settlement'
    end
  end
end
