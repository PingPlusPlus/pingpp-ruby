module Pingpp
  class SplitReceiver < APIResource
    extend Pingpp::APIOperations::Create
    extend Pingpp::APIOperations::List
    include Pingpp::APIOperations::Delete

    def self.object_name
      'split_receiver'
    end

    def self.resource_url(opts={})
      '/v1/split_receivers'
    end

  end
end
