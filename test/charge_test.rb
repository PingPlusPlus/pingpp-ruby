require File.expand_path('../test_assistant', __FILE__)
require "digest/md5"

module Pingpp
  class ChargeTest < Test::Unit::TestCase
    should "execute should return a new, fully executed charge when passed correct parameters" do
      order_no = Digest::MD5.hexdigest(Time.now.to_i.to_s)[0,12]
      channel = 'wx'

      params = {
        :order_no  => order_no,
        :app       => { :id => get_app_id },
        :channel   => channel, # 支付使用的第三方支付渠道取值，请参考：https://www.pingxx.com/api#api-c-new
        :amount    => 128000, # 订单总金额, 人民币单位：分（如订单总金额为 1 元，此处请填 100）
        :client_ip => "127.0.0.1", # 发起支付请求客户端的 IP 地址，格式为 IPV4，如: 127.0.0.1
        :currency  => "cny",
        :subject   => "Your Subject",
        :body      => "Your Body",
        :extra     => {}
      }

      c = Pingpp::Charge.create(params)

      assert c.order_no == params[:order_no]
      assert c.app == get_app_id
      assert c.channel == params[:channel]
      assert c.amount == params[:amount]
      assert c.paid == false
    end

    should "execute should return a charge list when passed correct parameters" do
      l = Pingpp::Charge.list(
        :app => { :id => get_app_id },
        :limit => 3,
        :paid => true,
        :refunded => false
      )

      assert l.object == 'list'
      assert l.data.count <= 3
    end

    should "execute should return an exist charge when passed correct charge id" do
      ch_id = get_charge_id
      c = Pingpp::Charge.retrieve(ch_id)

      assert c.object == 'charge'
      assert c.id == ch_id
    end
  end
end
