module Pingpp
  class CardInfo < APIResource
    extend Pingpp::APIOperations::Create

    def self.query(params={}, opts={})
        create(params, opts)
    end

    def self.resource_url(opts={})
      '/v1/card_info'
    end

  end
end
