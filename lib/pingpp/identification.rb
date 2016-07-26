module Pingpp
  class Identification < APIResource
    include Pingpp::APIOperations::Create

    def self.identify(params={}, api_key=nil)
        create(params, api_key)
    end

    def self.url
      '/v1/identification'
    end

  end
end
