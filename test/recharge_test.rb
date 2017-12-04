require File.expand_path('../test_assistant', __FILE__)
require "digest/md5"

module Pingpp
  class RechargeTest < Test::Unit::TestCase
    # 创建一笔充值 (recharge)
    should "execute should return a new, fully executed recharge when passed correct parameters" do
      order_no = Digest::MD5.hexdigest(Time.now.to_i.to_s)[0,12]

      params = {
        :user => get_user_id,
        :charge => {
          :order_no => order_no,
          :channel => "alipay", # 支付渠道
          :client_ip => "127.0.0.1", # 发起支付请求客户端的 IP 地址，格式为 IPV4，如: 127.0.0.1
          :amount => 100, # 订单总金额, 人民币单位：分（如订单总金额为 1 元，此处请填 100）
          :body => "Your Body",
          :subject => "You Subject",
          :extra => {} # 根据渠道填入参数 https://www.pingxx.com/api#支付渠道-extra-参数说明
        },
        :description => "充值描述"
      }

      o = Pingpp::Recharge.create(
        params,
        { :app => get_app_id } # App 信息
      )

      assert o.charge.order_no == params[:charge][:order_no]
      assert o.app == get_app_id
      assert o.object == "recharge"
      assert o.kind_of?(Pingpp::Recharge)
      assert o.charge.kind_of?(Pingpp::Charge)
    end

    # 查询一笔充值 (recharge)
    should "return an existed recharge when passed correct id" do
      o = Pingpp::Recharge.retrieve(
        existed_recharge_id,
        { :app => get_app_id } # App 信息
      )

      assert o.app == get_app_id
      assert o.object == "recharge"
      assert o.kind_of?(Pingpp::Recharge)
    end

    # 查询充值列表
    should "return a list object of recharge" do
      o = Pingpp::Recharge.list(
        { :per_page => 3, :page => 1 },
        { :app => get_app_id } # App 信息
      )

      assert o.kind_of?(Pingpp::ListObject)
      assert o.data[0].kind_of?(Pingpp::Recharge)
    end

    # 查询 recharge 的退款列表
    should "should return a refund list object of recharge" do
      recharge_id, _ = existed_refund_id_of_recharge
      o = Pingpp::Recharge.list_refunds(
        recharge_id, # Recharge 对象 ID
        { :per_page => 3, :page => 1 }, # 过滤参数，分页参数
        { :app => get_app_id } # App 信息
      )

      assert o.kind_of?(Pingpp::ListObject)
      assert o.data[0].kind_of?(Pingpp::Refund)
    end

    # 发起 recharge 的退款
    should "return a new refund object of recharge" do
      begin
        o = Pingpp::Recharge.refund(
          recharge_to_refund, # Recharge 对象 ID
          {
            # required.
            :description => '退款信息',
          },
          { :app => get_app_id } # App 信息
        )

        assert o.object == 'refund'
        assert o.kind_of?(Pingpp::Refund)
      rescue => e
        assert e.kind_of?(Pingpp::InvalidRequestError) || e.kind_of?(Pingpp::ChannelError)
        assert e.message.include?("可退金额为 0") || e.message.include?("refundable amount is 0")
      end
    end

    # 查询 recharge 的退款
    should "should return a refund object of recharge" do
      recharge_id, refund_id = existed_refund_id_of_recharge
      o = Pingpp::Recharge.retrieve_refund(
        recharge_id, # Recharge 对象 ID
        refund_id, # Refund 对象 ID
        { :app => get_app_id } # App 信息
      )

      assert o.object == 'refund'
      assert o.id == refund_id
      assert o.kind_of?(Pingpp::Refund)
    end
  end
end
