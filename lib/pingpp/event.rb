module Pingpp
  class Event < APIResource

    def self.resource_url(opts={})
      '/v1/events'
    end
  end
end
