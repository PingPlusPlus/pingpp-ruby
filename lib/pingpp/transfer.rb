module Pingpp
  class Transfer < APIResource
    include Pingpp::APIOperations::List
    include Pingpp::APIOperations::Create
    include Pingpp::APIOperations::Update

    def self.url
      '/v1/transfers'
    end

  end
end
