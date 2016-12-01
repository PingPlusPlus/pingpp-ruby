module Pingpp
  class BatchTransfer < APIResource
    extend Pingpp::APIOperations::Create
    extend Pingpp::APIOperations::List

    def self.object_name
      'batch_transfer'
    end

    def self.resource_url(opts={})
      '/v1/batch_transfers'
    end
  end
end
