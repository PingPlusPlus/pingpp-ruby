module Pingpp
  class Transfer < APIResource
    extend Pingpp::APIOperations::Create
    extend Pingpp::APIOperations::List

    def self.resource_url(opts={})
      '/v1/transfers'
    end

  end
end
