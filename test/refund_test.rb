require File.expand_path('../test_assistant', __FILE__)

module Pingpp
  class RefundTest < Test::Unit::TestCase
    should "execute should return a refund list when passed correct parameters" do
      l = Pingpp::Refund.list(get_charge_id, {:limit => 3})

      assert l.object == 'list'
      assert l.data.count <= 3
    end

    should "execute should return a refund when passed correct parameters" do
      ch_id = get_charge_id

      r = Pingpp::Refund.create(ch_id, {:amount => 1, :description => 'Refund amount test.'})

      assert r.object == 'refund'
      assert r.charge == ch_id
    end

    should "execute should return an exist refund when passed correct charge id and refund id" do
      re_id = get_refund_id
      ch_id = get_charge_id

      r = Pingpp::Refund.retrieve(ch_id, re_id)

      assert r.object == 'refund'
      assert r.id == re_id
      assert r.charge == ch_id
    end
  end
end
