module Pingpp
  class BatchWithdrawal < AppBasedResource
    extend Pingpp::APIOperations::Create
    extend Pingpp::APIOperations::List
    include Pingpp::APIOperations::Update

    def self.object_name
      'batch_withdrawal'
    end
  end
end
