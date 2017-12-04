require File.expand_path('../test_assistant', __FILE__)

module Pingpp
  class RoyaltyTransactionTest < Test::Unit::TestCase
    # 查询分润结算明细
    should "return an existed royalty_transaction object when passed a correct id" do
      o = Pingpp::RoyaltyTransaction.retrieve(existed_royalty_transaction_id)

      assert o.kind_of?(Pingpp::RoyaltyTransaction)
    end

    # 查询分润结算明细列表
    should "return a list object of royalty_transaction" do
      o = Pingpp::RoyaltyTransaction.list(
        { :per_page => 3, :page => 1 }
      )

      assert o.kind_of?(Pingpp::ListObject)
      if o.data.count > 0
        assert o.data[0].kind_of?(Pingpp::RoyaltyTransaction)
      end
    end
  end
end
