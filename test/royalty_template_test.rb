require File.expand_path('../test_assistant', __FILE__)

module Pingpp
  class RoyaltyTemplateTest < Test::Unit::TestCase
    # 创建分润模版
    should "return a royalty_template object when passed correct parameters" do
      params = {
        # App ID  required|string
        :app => get_app_id,

        # 描述信息  optional|string
        :description => "TEMPLATE DESCRIPTION",

        # 模版名称  optional|string
        # :name => "TEMPLATE_NAME",

        # 分润规则  required|hash
        :rule => {
          # 分润模式  required|string; rate: 按订单金额（包含优惠券金额）的比例, fixed: 固定金额
          :royalty_mode => "rate",

          # 分配模式  required|string; 指当订单确定的层级如果少于模板配置层级时，
          # 模板中多余的分润金额是归属于收款方 `receipt_reserved` 还是服务方 `service_reserved`。
          :allocation_mode => "receipt_reserved",

          # 退分润模式  required|string; no_refund: 退款时不退分润, proportional: 按比例退分润, full_refund: 一旦退款分润全退
          :refund_mode => "no_refund",

          # 分润数据列表  required|array
          :data => [
            {
              :level => 0,
              :value => 10
            },
            {
              :level => 1,
              :value => 20
            }
          ],
        },
      }

      o = Pingpp::RoyaltyTemplate.create(params)

      assert o.kind_of?(Pingpp::RoyaltyTemplate)
    end

    # 查询分润模版
    should "return an existed royalty_template object when passed a correct id" do
      o = Pingpp::RoyaltyTemplate.retrieve(existed_royalty_template_id)

      assert o.kind_of?(Pingpp::RoyaltyTemplate)
    end

    # 查询分润模版列表
    should "return a list object of royalty_template" do
      o = Pingpp::RoyaltyTemplate.list(
        { :per_page => 3, :page => 1 }
      )

      assert o.kind_of?(Pingpp::ListObject)
      assert o.data[0].kind_of?(Pingpp::RoyaltyTemplate)
    end

    # 更新分润模版
    should "return a updated royalty_template" do
      params = {
        :description => "New description #{Time.now.to_i.to_s}",
        :rule => {
          :royalty_mode => "rate",
          :allocation_mode => "receipt_reserved",
          :refund_mode => "no_refund",
          :data => [
            { :level => 0, :value => 20 },
            { :level => 1, :value => 30 }
          ],
        },
      }
      o = Pingpp::RoyaltyTemplate.update(
        existed_royalty_template_id,
        params
      )

      assert o.kind_of?(Pingpp::RoyaltyTemplate)
      assert o.description == params[:description]
      assert o.rule.data[0].value == params[:rule][:data][0][:value]
    end

    # 删除分润模版
    should "return deleted object with royalty template id" do
      begin
        o = Pingpp::RoyaltyTemplate.delete(royalty_template_id_to_delete)

        assert o.id == royalty_template_id_to_delete
        assert o.deleted
      rescue => e
        assert e.kind_of?(Pingpp::InvalidRequestError)
        assert e.message.include?("找不到分润模板对象")
      end
    end
  end
end
