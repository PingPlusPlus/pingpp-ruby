require File.expand_path('../test_assistant', __FILE__)
require "digest/md5"

module Pingpp
  class SettleAccountTest < Test::Unit::TestCase
    should "settle_account create" do
      params = {
        :channel => 'wx_pub',
        :recipient => {
          :account => 'oazpsj-ejmwkkskuggaj2h2kaz8ah'
        }
      }

      u = Pingpp::SettleAccount.create(params, {:user => get_user_id})

      assert u.object == 'settle_account'
      assert u.channel == params[:channel]
    end

    should "settle_account retrieve" do
      u = Pingpp::SettleAccount.retrieve('320217041815593200000501', {:user => get_user_id})

      assert u.object == 'settle_account'
      assert u.id == '320217041815593200000501'
    end

    should "settle_account list" do
      l = Pingpp::SettleAccount.list({:per_page => 3}, {:user => get_user_id})

      assert l.object == 'list'
      assert l.data.count <= 3
    end

    should "settle_account delete" do
      d = Pingpp::SettleAccount.delete('320217080118072300000201', {}, {:user => get_user_id})

      assert d.deleted
      assert d.id == '320217080118072300000201'
    end
  end
end
