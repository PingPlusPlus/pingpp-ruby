module Pingpp
  class SettleAccount < UserBasedResource
    extend Pingpp::APIOperations::Create
    extend Pingpp::APIOperations::List
    include Pingpp::APIOperations::Delete
    include Pingpp::APIOperations::Update

    def self.object_name
      'settle_account'
    end
  end
end
