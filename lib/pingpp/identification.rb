module Pingpp
  class Identification < APIResource
    extend Pingpp::APIOperations::Create

    def self.identify(params={}, opts={})
        create(params, opts)
    end

    def self.resource_url(opts={})
      '/v1/identification'
    end

  end
end
