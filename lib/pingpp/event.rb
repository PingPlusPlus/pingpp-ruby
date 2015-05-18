module Pingpp
  class Event < APIResource
    include Pingpp::APIOperations::List

    def self.url
      '/v1/events'
    end

  end
end
