module Pingpp
  class Customs < APIResource
    extend Pingpp::APIOperations::Create
    extend Pingpp::APIOperations::List

    def self.resource_url(opts={})
      '/v1/customs'
    end
  end
end
