require File.expand_path('../test_assistant', __FILE__)

module Pingpp
  class BalanceTransactionTest < Test::Unit::TestCase
    should "execute should return a balance_transaction list when passed correct parameters" do
      txns = Pingpp::BalanceTransaction.list({:per_page => 3})

      assert txns.object == 'list'
      assert txns.data.count <= 3
    end

    should "execute should return an exist balance_transaction when passed correct id" do
      txn = Pingpp::BalanceTransaction.retrieve(get_txn_id)

      assert txn.object == 'balance_transaction'
      assert txn.id == get_txn_id
    end
  end
end
