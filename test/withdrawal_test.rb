require File.expand_path('../test_assistant', __FILE__)

module Pingpp
  class WithdrawalTest < Test::Unit::TestCase
    # 创建提现
    should "return an withdrawal object when passed correct parameters" do
      params = {
        # 提现用户 ID  optional|string
        :user => existed_user_id,

        # 提现金额  required|integer
        :amount => 10,

        # 提现用户手续费  optional|integer
        :user_fee => 0,

        # 描述信息  optional|string
        :description => "用户提现",

        # 提现渠道  required|string
        :channel => "alipay",

        # 用户账号相关额外参数  conditional|hash; 使用 settle_account 时不需要此参数
        :extra => {
          # 收款账号  conditional|string; alipay 渠道为支付宝账号或 ID
          :account => "user@gmail.com",

          # 姓名  conditional|string
          :name => "姓名",
        },

        # 结算账号 ID  conditional|string; 与 user 绑定的结算账号 ID
        # :settle_account => "SETTLE_ACCOUNT",

        # metadata  optional|hash
        :metadata => {
          :custom_key => "custom_value",
          # ...
        }
      }

      if params[:channel] == "allinpay"
        params[:order_no] = "301002#{Time.now.to_i.to_s}#{rand(999999).to_s.rjust(6, "0")}"
      else
        params[:order_no] = "#{Time.now.to_i.to_s}#{rand(9999).to_s.rjust(4, "0")}"
      end

      o = Pingpp::Withdrawal.create(
        params,
        {
          # URL 中的 {app_id}  optional|string; 用于覆盖 Pingpp.app_id
          :app => get_app_id
        }
      )

      assert o.kind_of?(Pingpp::Withdrawal)
      assert o.order_no == params[:order_no]
      assert o.app == get_app_id
      assert o.amount == params[:amount]
      assert o.user == params[:user]
    end

    # 提现确认
    should "return an pending withdrawal when passed a created withdrawal id" do
      begin
        o = Pingpp::Withdrawal.confirm(
          existed_withdrawal_id,
          { :app => get_app_id } # App 信息
        )

        assert o.id == existed_withdrawal_id
        assert o.app == get_app_id
        assert o.kind_of?(Pingpp::Withdrawal)
      rescue => e
        assert e.kind_of?(Pingpp::InvalidRequestError)
        assert e.message.include?("不能被更新状态") || e.message.include?("cannot be updated")
      end
    end

    # 提现取消
    should "return an canceled withdrawal when passed a created withdrawal id" do
      begin
        o = Pingpp::Withdrawal.cancel(
          existed_withdrawal_id,
          { :app => get_app_id } # App 信息
        )

        assert o.id == existed_withdrawal_id
        assert o.app == get_app_id
        assert o.status == "canceled"
        assert o.kind_of?(Pingpp::Withdrawal)
      rescue => e
        assert e.kind_of?(Pingpp::InvalidRequestError)
        assert e.message.include?("不能被更新状态") || e.message.include?("cannot be updated")
      end
    end

    # 查询提现
    should "return an existed withdrawal when passed correct id" do
      o = Pingpp::Withdrawal.retrieve(
        existed_withdrawal_id,
        { :app => get_app_id } # App 信息
      )

      assert o.id == existed_withdrawal_id
      assert o.app == get_app_id
      assert o.kind_of?(Pingpp::Withdrawal)
    end

    # 查询提现列表
    should "return a list object of withdrawal" do
      o = Pingpp::Withdrawal.list(
        { :per_page => 3, :page => 1 },
        { :app => get_app_id } # App 信息
      )

      assert o.kind_of?(Pingpp::ListObject)
      assert o.data[0].kind_of?(Pingpp::Withdrawal)
    end
  end
end
