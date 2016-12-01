module Pingpp
  class BatchRefund < APIResource
    extend Pingpp::APIOperations::Create
    extend Pingpp::APIOperations::List

    def self.object_name
      'batch_refund'
    end

    def self.resource_url(opts={})
      '/v1/batch_refunds'
    end
  end
end
