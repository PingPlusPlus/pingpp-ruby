module Pingpp
  class BalanceBonus < AppBasedResource
    extend Pingpp::APIOperations::List
    extend Pingpp::APIOperations::Create

    def self.object_name
      'balance_bonus'
    end

    def self.uri_object_name
      "#{object_name}e"
    end
  end
end
