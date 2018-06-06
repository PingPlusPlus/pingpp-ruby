require File.expand_path('../test_assistant', __FILE__)

module Pingpp
  class BalanceSettlementTest < Test::Unit::TestCase
    should "execute should return a balance_settlement list when passed correct parameters" do
      bss = Pingpp::BalanceSettlement.list({:per_page => 3})

      assert bss.object == 'list'
      assert bss.data.count <= 3
    end

    should "execute should return an exist balance_settlement when passed correct id" do
      bs = Pingpp::BalanceSettlement.retrieve(get_bs_id)

      assert bs.object == 'balance_settlement'
      assert bs.id == get_bs_id
    end
  end
end
