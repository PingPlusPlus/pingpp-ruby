module Pingpp
  class CouponTemplate < AppBasedResource
    extend Pingpp::APIOperations::Create
    extend Pingpp::APIOperations::List
    include Pingpp::APIOperations::Delete
    include Pingpp::APIOperations::Update

    def self.object_name
      'coupon_template'
    end

    def self.list_coupons(coupon_template, filters={}, opts={})
      opts = Util.normalize_opts(opts)
      response, opts = request(:get, coupon_url(coupon_template, opts), filters, opts)
      ListObject.construct_from(response, opts)
    end

    def self.create_coupons(coupon_template, params={}, opts={})
      response, opts = request(:post, coupon_url(coupon_template, opts), params, opts)
      Util.convert_to_pingpp_object(response, opts)
    end

    private

    def self.coupon_url(coupon_template, opts={})
      resource_url(opts) + "/#{coupon_template}/coupons"
    end
  end
end
