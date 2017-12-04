module Pingpp
  class Recharge < AppBasedResource
    extend Pingpp::APIOperations::Create
    extend Pingpp::APIOperations::List

    def refund(params, opts={})
      response, opts = request(:post, refund_url, params, opts)
      initialize_from(response, opts)
    end

    def self.refund(id, params, opts={})
      response, opts = request(:post, refund_url(id), params, opts)
      Util.convert_to_pingpp_object(response, opts)
    end

    def self.retrieve_refund(id, refund_id, opts={})
      response, opts = request(:get, "#{refund_url(id)}/#{refund_id}", {}, opts)
      Util.convert_to_pingpp_object(response, opts)
    end

    def self.list_refunds(id, params={}, opts={})
      response, opts = request(:get, refund_url(id), params, opts)
      Util.convert_to_pingpp_object(response, opts)
    end

    private

    def refund_url
      resource_url + '/refunds'
    end

    def self.refund_url(id)
      "#{resource_url}/#{id}/refunds"
    end
  end
end
