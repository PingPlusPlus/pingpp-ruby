module Pingpp
  class Withdrawal < AppBasedResource
    extend Pingpp::APIOperations::Create
    extend Pingpp::APIOperations::List
    include Pingpp::APIOperations::Update

    def self.cancel(id, opts={})
      update(id, {:status => 'canceled'}, opts)
    end

    def self.confirm(id, opts={})
      update(id, {:status => 'pending'}, opts)
    end
  end
end
