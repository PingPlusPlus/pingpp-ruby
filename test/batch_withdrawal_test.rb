require File.expand_path('../test_assistant', __FILE__)

module Pingpp
  class BatchWithdrawalTest < Test::Unit::TestCase
    # 创建 batch_withdrawal (确认)
    should "return a batch_withdrawal object when passed correct parameters" do
      withdrawal_ids = get_created_withdrawals
      if withdrawal_ids.count > 0
        params = {
          :withdrawals  => withdrawal_ids,

          # optional|string; 确认为 pending，取消为 canceled
          :status => "pending",
        }
        o = Pingpp::BatchWithdrawal.create(params)

        assert o.kind_of?(Pingpp::BatchWithdrawal)
      end
    end

    # 创建 batch_withdrawal (取消)
    should "return a batch_withdrawal(canceled) object when passed correct parameters" do
      withdrawal_ids = get_created_withdrawals
      if withdrawal_ids.count > 0
        params = {
          :withdrawals  => withdrawal_ids,

          # optional|string; 确认为 pending，取消为 canceled
          :status => "canceled",
        }
        o = Pingpp::BatchWithdrawal.create(params)

        assert o.kind_of?(Pingpp::BatchWithdrawal)
      end
    end

    # 查询单笔 batch_withdrawal
    should "return an existed batch_withdrawal object when passed correct id" do
      o = Pingpp::BatchWithdrawal.retrieve(existed_batch_withdrawal_id)

      assert o.kind_of?(Pingpp::BatchWithdrawal)
    end

    # 查询 batch_withdrawal 列表
    should "return a batch_withdrawal list object" do
      params = {
        :page => 1,
        :per_page => 3,
      }
      o = Pingpp::BatchWithdrawal.list(params)

      assert o.kind_of?(Pingpp::ListObject)
      assert o.data[0].kind_of?(Pingpp::BatchWithdrawal)
    end

    def get_created_withdrawals
      o = Pingpp::Withdrawal.list(
        {
          :per_page => 1,
          :page => 1,
          :status => 'created',
          :channel => 'alipay',
          :created => { :gte => 1503158400 }
        },
        { :app => get_app_id } # App 信息
      )

      withdrawals = []
      o.data.each { |withdrawal|
        withdrawals.push(withdrawal.id)
      }

      return withdrawals
    end
  end
end
