module Pingpp
  class Charge < APIResource
    include Pingpp::APIOperations::List
    include Pingpp::APIOperations::Create
    include Pingpp::APIOperations::Update

    private

    def refund_url
      url + '/refunds'
    end
  end
end
