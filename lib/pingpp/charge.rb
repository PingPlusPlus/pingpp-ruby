module Pingpp
  class Charge < APIResource
    extend Pingpp::APIOperations::Create
    extend Pingpp::APIOperations::List

    private

    def refund_url
      resource_url + '/refunds'
    end
  end
end
