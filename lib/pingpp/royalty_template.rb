module Pingpp
  class RoyaltyTemplate < APIResource
    extend Pingpp::APIOperations::Create
    extend Pingpp::APIOperations::List
    include Pingpp::APIOperations::Update
    include Pingpp::APIOperations::Delete

    def self.object_name
      'royalty_template'
    end
  end
end
