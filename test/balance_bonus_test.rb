require File.expand_path('../test_assistant', __FILE__)
require "digest/md5"

module Pingpp
  class BalanceBonusTest < Test::Unit::TestCase
    # 创建 balance_bonus 余额赠送
    should "execute should return a new balance_bonus when passed correct parameters" do
      order_no = Digest::MD5.hexdigest(Time.now.to_i.to_s)[0,12]

      params = {
        :order_no => order_no, # 余额赠送订单号
        :amount => 100, # 金额, 人民币单位：分（如订单总金额为 1 元，此处请填 100）
        :user => existed_user_id, # 收款用户
        :description   => "余额赠送"
      }

      o = Pingpp::BalanceBonus.create(
        params,
        { :app => get_app_id }
      )

      assert o.order_no == params[:order_no]
      assert o.app == get_app_id
      assert o.amount == 100
      assert o.user == params[:user]
      assert o.kind_of?(Pingpp::BalanceBonus)
    end

    should "execute should return an balance_bonus list when passed correct parameters" do
      o = Pingpp::BalanceBonus.list(
        { :per_page => 3 },
        { :app => get_app_id }
      )

      assert o.object == 'list'
      assert o.data.count <= 3
      assert o.kind_of?(Pingpp::ListObject)
      assert o.data[0].kind_of?(Pingpp::BalanceBonus)
    end

    should "execute should return an exist balance_bonus when passed correct id" do
      o = Pingpp::BalanceBonus.retrieve(
        existed_balance_bonus_id,
        { :app => get_app_id }
      )

      assert o.object == 'balance_bonus'
      assert o.kind_of?(Pingpp::BalanceBonus)
    end
  end
end
