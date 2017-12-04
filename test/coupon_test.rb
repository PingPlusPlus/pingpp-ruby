require File.expand_path('../test_assistant', __FILE__)

module Pingpp
  class CouponTest < Test::Unit::TestCase
    # 为用户创建优惠券
    should "return a new coupon for user when passed correct parameters" do
      begin
        o = Pingpp::Coupon.create(
          { :coupon_template => existed_coupon_template_id },
          { :user => get_user_id }
        )

        assert o.kind_of?(Pingpp::Coupon)
      rescue => e
        assert e.kind_of?(Pingpp::InvalidRequestError) || e.kind_of?(Pingpp::ChannelError)
        assert e.message.include?("优惠券已到达当前用户最大生成数量") || e.message.include?("coupon exceed max user circulation")
      end
    end

    # 查询用户的优惠券列表
    should "execute should return a coupon when passed correct parameters" do
      coupons = Pingpp::Coupon.list({:per_page => 3}, {:user => get_user_id})

      assert coupons.kind_of?(Pingpp::ListObject)
      assert coupons.data.count <= 3
      assert coupons.data[0].kind_of?(Pingpp::Coupon)
    end

    # 查询用户的优惠券
    should "execute should return a coupon object when passed correct parameters" do
      coupon_id, user_id = coupon_id_and_user
      coupon = Pingpp::Coupon.retrieve(coupon_id, {:user => user_id})

      assert coupon.kind_of?(Pingpp::Coupon)
    end

    # 更新用户的优惠券
    should "return a updated coupon object when passed correct id and parameters" do
      coupon_id, user_id = coupon_id_and_user_to_update
      o = Pingpp::Coupon.update(
        coupon_id,
        { :metadata => { :new_key => 'new value' } },
        { :user => user_id }
      )

      assert o.kind_of?(Pingpp::Coupon)
    end

    # 删除用户的优惠券
    should "execute should return a deleted object when passed correct parameters" do
      coupon_id, user_id = coupon_id_and_user_to_delete
      begin
        deleted = Pingpp::Coupon.delete(coupon_id, {}, {:user => user_id})

        assert deleted.deleted
      rescue => e
        assert e.kind_of?(Pingpp::InvalidRequestError)
        assert e.message.include?("未找到") || e.message.include?("No such coupon")
      end
    end

    # 使用优惠券模板批量创建优惠券
    should "execute should return a coupon list made from coupon_template when passed correct coupon_template_id and parameters" do
      user_id = Digest::MD5.hexdigest(Time.now.to_i.to_s)[0,12]
      coupons = Pingpp::CouponTemplate.create_coupons(get_coupon_template_id, {:users => [user_id]})

      assert coupons.kind_of?(Pingpp::ListObject)
      assert coupons.data.count <= 3
      assert coupons.data[0].kind_of?(Pingpp::Coupon)
    end

    # 查询优惠券模板创建的优惠券列表
    should "execute should return a coupon list made from coupon_template when passed correct coupon_template_id" do
      coupons = Pingpp::CouponTemplate.list_coupons(get_coupon_template_id, {:per_page => 3})

      assert coupons.kind_of?(Pingpp::ListObject)
      assert coupons.object == 'list'
      assert coupons.data.count <= 3
    end
  end
end
