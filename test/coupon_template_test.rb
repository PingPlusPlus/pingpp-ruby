require File.expand_path('../test_assistant', __FILE__)
require "digest/md5"

module Pingpp
  class CouponTemplateTest < Test::Unit::TestCase
    # 创建优惠券模版
    should "execute should return a new coupon_template when passed correct parameters" do
      ctmpl = Pingpp::CouponTemplate.create({
        # 类型  required|integer; 优惠券模板的类型 1：现金券；2：折扣券
        :type => 1,

        # 折扣金额  conditional|integer; 当 type 为 1 时，必传。
        :amount_off => 30,

        # 折扣百分比  conditional|integer; 例: 20 表示 8 折, 100 表示免费。当 type 为 2 时，必传。
        # :percent_off => 15,

        # optional|integer; 订单金额大于等于该值时，优惠券有效（适用于满减）；0 表示无限制，默认 0。
        :amount_available => 100,
      })

      assert ctmpl.kind_of?(Pingpp::CouponTemplate)
    end

    # 查询优惠券模板列表
    should "execute should return a coupon_template list when passed correct parameters" do
      ctmpl = Pingpp::CouponTemplate.list({:per_page => 3})

      assert ctmpl.kind_of?(Pingpp::ListObject)
      assert ctmpl.data.count <= 3
      assert ctmpl.data[0].kind_of?(Pingpp::CouponTemplate)
    end

    # 查询优惠券模板
    should "execute should return an exist coupon_template when passed correct id" do
      ctmpl = Pingpp::CouponTemplate.retrieve(get_coupon_template_id)

      assert ctmpl.kind_of?(Pingpp::CouponTemplate)
      assert ctmpl.object == 'coupon_template'
      assert ctmpl.id == get_coupon_template_id
    end

    # 更新优惠券模板
    should "execute should return an updated coupon_template when passed correct id" do
      new_params = { :metadata => { :custom_key => Digest::MD5.hexdigest(Time.now.to_i.to_s)[0,12] }}
      ctmpl = Pingpp::CouponTemplate.update(
        get_coupon_template_id,
        new_params
      )

      assert ctmpl.kind_of?(Pingpp::CouponTemplate)
      assert ctmpl.id == get_coupon_template_id
      assert ctmpl.metadata.custom_key == new_params[:metadata][:custom_key]
    end

    # 删除优惠券模板
    should "return a deleted object when passed existed coupon_template id" do
      begin
        o = Pingpp::CouponTemplate.delete(coupon_template_id_to_delete)

        assert o.deleted
      rescue => e
        assert e.kind_of?(Pingpp::InvalidRequestError)
        assert e.message.include?("未找到") || e.message.include?("No such coupon_template")
      end
    end
  end
end
