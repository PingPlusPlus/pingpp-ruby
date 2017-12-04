require File.expand_path('../test_assistant', __FILE__)
require "digest/md5"

module Pingpp
  class OrderTest < Test::Unit::TestCase
    # 创建订单 (order)
    should "execute should return a new, fully executed order when passed correct parameters" do
      order_no = Digest::MD5.hexdigest(Time.now.to_i.to_s)[0,12]

      params = {
        :merchant_order_no  => order_no,
        :app       => get_app_id,
        :amount    => 100, # 订单总金额, 人民币单位：分（如订单总金额为 1 元，此处请填 100）
        :client_ip => "127.0.0.1", # 发起支付请求客户端的 IP 地址，格式为 IPV4，如: 127.0.0.1
        :currency  => "cny",
        :subject   => "Your Subject",
        :body      => "Your Body",
        :uid       => get_user_id,

        # 分润信息  optional|hash; 指定用户的形式
        :royalty_users => [
          { :user => 'user_007', :amount => 30 },
          { :user => 'test_user_001', :amount => 20 },
        ],

        # 分润模版  optional|string; 该参数与 royalty_users 同时传时，会忽略 royalty_template
        # :royalty_template => existed_royalty_template_id,
      }

      o = Pingpp::Order.create(params)

      assert o.merchant_order_no == params[:merchant_order_no]
      assert o.app == get_app_id
      assert o.amount == 100
      assert o.paid == false
    end

    # 查询订单列表
    should "execute should return an order list when passed correct parameters" do
      o = Pingpp::Order.list(
        {
          :app => get_app_id,
          :per_page => 3,
          :paid => true,
          :refunded => false,
        }
      )

      assert o.object == 'list'
      assert o.data.count <= 3
      assert o.kind_of?(Pingpp::ListObject)
      assert o.data[0].kind_of?(Pingpp::Order)
    end

    # 取消一笔订单
    should "execute should return an canceled order when passed correct id" do
      begin
        o = Pingpp::Order.cancel(order_to_cancel)

        assert o.object == 'order'
        assert o.kind_of?(Pingpp::Order)
        assert o.status == 'canceled'
      rescue => e
        assert e.kind_of?(Pingpp::InvalidRequestError)
        assert e.message.include?("已取消") || e.message.include?("canceled") ||
          e.message.include?("expired") || e.message.include?("已过期")
      end

    end

    # 查询一笔存在的订单
    should "execute should return an exist order when passed correct id" do
      o = Pingpp::Order.retrieve(existed_order_id)

      assert o.object == 'order'
      assert o.kind_of?(Pingpp::Order)
      assert o.id == existed_order_id
    end

    # 为一笔已创建的订单创建支付 (charge)
    should "execute should return an order with credential when passed correct id and parameters" do
      begin
        o = Pingpp::Order.pay(
          order_to_pay,
          {
            :charge_amount => 1000,
            :channel => 'balance'
          }
        )

        assert o.kind_of?(Pingpp::Order)
      rescue => e
        assert e.kind_of?(Pingpp::InvalidRequestError)
        assert e.message.include?("已支付") || e.message.include?("paid")
      end
    end

    # 查询 order 的 charge 列表
    should "return a charge list object" do
      order_id, _ = existed_charge_id_of_order
      o = Pingpp::Order.list_charges(
        order_id,
        { :per_page => 3, :page => 1 }
      )

      assert o.object == 'list'
      assert o.kind_of?(Pingpp::ListObject)
      assert o.data[0].kind_of?(Pingpp::Charge)
    end

    # 查询 order 的 charge 对象
    should "should return a charge object" do
      order_id, charge_id = existed_charge_id_of_order
      o = Pingpp::Order.retrieve_charge(
        order_id,
        charge_id
      )

      assert o.kind_of?(Pingpp::Charge)
    end

    # 查询 order 的退款列表
    should "should return a list object of refunds already created" do
      order_id, _ = existed_refund_id_of_order
      o = Pingpp::Order.list_refunds(
        order_id,
        { :per_page => 3, :page => 1 }
      )

      assert o.object == 'list'
      assert o.kind_of?(Pingpp::ListObject)
      assert o.data[0].kind_of?(Pingpp::Refund)
    end

    # 发起 order 的退款
    should "should return a list object of new refunds" do
      order_id, charge_id = order_and_charge_to_refund
      o = Pingpp::Order.refund(
        order_id,
        {
          # optional. 要退款的 Charge ID，不填则将 Order 包含的所有 Charge 都退款。
          :charge => charge_id,

          # optional. 退款金额，不填则退剩余可退金额。
          :charge_amount => 1,

          # required.
          :description => '退款信息',

          # optional. 退款模式。原路退回：to_source，退至余额：to_balance。默认为原路退回。
          :refund_mode => 'to_source',

          # optional. 退款资金来源。unsettled_funds：使用未结算资金退款；recharge_funds：使用可用余额退款。
          # 该参数仅适用于所有微信渠道，包括 wx、wx_pub、wx_pub_qr、wx_lite、wx_wap 五个渠道。
          # :funding_source => 'unsettled_funds',

          # optional. 退分润的用户列表，默认分润全退，不是分润全退时，需要填写所有分润的用户。
          # :royalty_users => [
          #   { :user => '', :amount_refunded => 10 }
          # ],
        }
      )

      assert o.object == 'list'
      assert o.kind_of?(Pingpp::ListObject)
      assert o.data[0].kind_of?(Pingpp::Refund)
    end

    # 查询 order 的退款
    should "should return a refund object" do
      order_id, refund_id = existed_refund_id_of_order
      o = Pingpp::Order.retrieve_refund(
        order_id,
        refund_id
      )

      assert o.kind_of?(Pingpp::Refund)
      assert o.id == refund_id
    end
  end
end
