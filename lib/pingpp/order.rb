module Pingpp
  class Order < APIResource
    extend Pingpp::APIOperations::Create
    extend Pingpp::APIOperations::List
    include Pingpp::APIOperations::Update

    def pay(params, opts={})
      response, opts = request(:post, pay_url, params, opts)
      initialize_from(response, opts)
    end

    def self.pay(id, params, opts={})
      response, opts = request(:post, pay_url(id), params, opts)
      Util.convert_to_pingpp_object(response, opts)
    end

    def self.cancel(id, opts={})
      update(id, {:status => 'canceled'}, opts)
    end

    def self.retrieve_charge(id, charge_id, opts={})
      response, opts = request(:get, "#{resource_url}/#{id}/charges/#{charge_id}", {}, opts)
      Util.convert_to_pingpp_object(response, opts)
    end

    def self.list_charges(id, params={}, opts={})
      response, opts = request(:get, "#{resource_url}/#{id}/charges", params, opts)
      Util.convert_to_pingpp_object(response, opts)
    end

    def self.refund(id, params, opts={})
      response, opts = request(:post, refund_url(id), params, opts)
      Util.convert_to_pingpp_object(response, opts)
    end

    def refund(params, opts={})
      response, opts = request(:post, refund_url, params, opts)
      initialize_from(response, opts)
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

    def pay_url
      resource_url + '/pay'
    end

    def self.pay_url(order)
      "#{resource_url}/#{order}/pay"
    end

    def refund_url
      resource_url + '/order_refunds'
    end

    def self.refund_url(order)
      "#{resource_url}/#{order}/order_refunds"
    end
  end
end
