module Pingpp
  class BatchTransfer < APIResource
    extend Pingpp::APIOperations::Create
    extend Pingpp::APIOperations::List
    include Pingpp::APIOperations::Update

    def self.object_name
      'batch_transfer'
    end

    def self.resource_url(opts={})
      '/v1/batch_transfers'
    end

    def self.cancel(id, opts={})
      update(id, {:status => 'canceled'}, opts)
    end
  end
end
