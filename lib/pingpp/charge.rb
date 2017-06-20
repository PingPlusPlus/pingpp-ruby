module Pingpp
  class Charge < APIResource
    extend Pingpp::APIOperations::Create
    extend Pingpp::APIOperations::List

    def self.reverse(id, opts={})
      id, reverse_params = Util.normalize_id(id)
      response, opts = request(:post, "#{resource_url(opts)}/#{CGI.escape(id)}/reverse", reverse_params, opts)
      Util.convert_to_pingpp_object(response, opts)
    end

    private

    def refund_url
      resource_url + '/refunds'
    end
  end
end
