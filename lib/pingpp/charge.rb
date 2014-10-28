module Pingpp
  class Charge < APIResource
    include Pingpp::APIOperations::List
    include Pingpp::APIOperations::Create
    include Pingpp::APIOperations::Update

    def refund(params={})
      response, api_key = Pingpp.request(:post, refund_url, @api_key, params)
      refresh_from(response, api_key)
      self
    end

    private

    def refund_url
      url + '/refunds'
    end
  end
end
