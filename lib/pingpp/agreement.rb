module Pingpp
  class Agreement < APIResource
    extend Pingpp::APIOperations::Create
    extend Pingpp::APIOperations::List
    include Pingpp::APIOperations::Update

    def self.cancel(id, opts={})
      update(id, {:status => 'canceled'}, opts)
    end
  end
end
