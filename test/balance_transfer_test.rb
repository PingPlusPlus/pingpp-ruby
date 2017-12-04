require File.expand_path('../test_assistant', __FILE__)
require "digest/md5"

module Pingpp
  class BalanceTransferTest < Test::Unit::TestCase
    # 创建 balance_transfer
    should "execute should return a new balance_transfer when passed correct parameters" do
      order_no = Digest::MD5.hexdigest(Time.now.to_i.to_s)[0,12]

      params = {
        :order_no  => order_no, # 转账订单号
        :amount    => 1, # 转账总金额, 人民币单位：分（如订单总金额为 1 元，此处请填 100）
        :user => existed_user_id_for_balance_transfer, # 转出用户
        :recipient => existed_user_id, # 转入用户
        :description   => "用户间转账" # 描述
      }

      o = Pingpp::BalanceTransfer.create(
        params,
        { :app => get_app_id }
      )

      assert o.order_no == params[:order_no]
      assert o.app == get_app_id
      assert o.amount == params[:amount]
      assert o.user == params[:user]
      assert o.recipient == params[:recipient]
      assert o.kind_of?(Pingpp::BalanceTransfer)
    end

    # 查询 balance_transfer 列表
    should "execute should return an balance_transfer list when passed correct parameters" do
      o = Pingpp::BalanceTransfer.list(
        { :per_page => 3 },
        { :app => get_app_id }
      )

      assert o.object == 'list'
      assert o.data.count <= 3
      assert o.kind_of?(Pingpp::ListObject)
      assert o.data[0].kind_of?(Pingpp::BalanceTransfer)
    end

    # 查询单笔 balance_transfer
    should "execute should return an exist balance_transfer when passed correct id" do
      o = Pingpp::BalanceTransfer.retrieve(
        existed_balance_transfer_id,
        { :app => get_app_id }
      )

      assert o.object == 'balance_transfer'
      assert o.kind_of?(Pingpp::BalanceTransfer)
    end
  end
end
