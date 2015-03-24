module Pingpp
  class RedEnvelope < APIResource
    include Pingpp::APIOperations::List
    include Pingpp::APIOperations::Create

    def self.url
      '/v1/red_envelopes'
    end

  end
end
