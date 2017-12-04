require File.expand_path('../test_assistant', __FILE__)

module Pingpp
  class RoyaltySettlementTest < Test::Unit::TestCase
    # 创建分润结算
    should "return a royalty_settlement object when passed correct params" do
      params = {
        # 分润发起方所在的 App ID  required|string
        :payer_app => get_payer_app,

        # 分润的方式  required|string,null; 余额 balance 或渠道名称 [alipay, wx_pub, unionpay, ...]
        :method => "alipay",

        # 分润创建时间  optional|hash
        :created => {
          :gte => 1504875000,
          :lt => 1504885000
        },
      }

      begin
        o = Pingpp::RoyaltySettlement.create(params)

        assert o.kind_of?(Pingpp::RoyaltySettlement)
      rescue => e
        assert e.kind_of?(Pingpp::InvalidRequestError)
        assert e.message.include?("无有效")
      end
    end

    # 查询分润结算对象
    should "return an existed royalty_settlement object when passed a correct id" do
      o = Pingpp::RoyaltySettlement.retrieve(existed_royalty_settlement_id)

      assert o.kind_of?(Pingpp::RoyaltySettlement)
    end

    # 更新/取消分润结算对象
    should "return an updated royalty_settlement object when passed a correct id" do
      begin
        o = Pingpp::RoyaltySettlement.update(
          existed_royalty_settlement_id,
          {
            # 更新状态 required|string; canceled: 取消结算, pending: 确认结算
            :status => 'canceled'
          }
        )

        assert o.kind_of?(Pingpp::RoyaltySettlement)
      rescue => e
        assert e.kind_of?(Pingpp::InvalidRequestError) || e.kind_of?(Pingpp::ChannelError)
        assert e.message.include?("状态错误")
      end
    end

    # 查询分润结算对象列表
    should "return a list object of royalty_settlement" do
      o = Pingpp::RoyaltySettlement.list(
        { :per_page => 3, :page => 1, :payer_app => get_payer_app }
      )

      assert o.kind_of?(Pingpp::ListObject)
      if o.data.count > 0
        assert o.data[0].kind_of?(Pingpp::RoyaltySettlement)
      end
    end
  end
end
