module Pingpp
  class Transfer < APIResource
    include Pingpp::APIOperations::List
    include Pingpp::APIOperations::Create

    def self.url
      '/v1/transfers'
    end

  end
end
