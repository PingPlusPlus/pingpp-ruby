module Pingpp
  class Transfer < APIResource
    extend Pingpp::APIOperations::Create
    extend Pingpp::APIOperations::List
    include Pingpp::APIOperations::Update

    def self.resource_url(opts={})
      '/v1/transfers'
    end

    def self.cancel(id, opts={})
      update(id, {:status => 'canceled'}, opts)
    end

  end
end
