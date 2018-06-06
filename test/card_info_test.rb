require File.expand_path('../test_assistant', __FILE__)

module Pingpp
  class CardInfoTest < Test::Unit::TestCase
    should "execute should return card info" do
      # 该接口仅支持 live key
      card_info = Pingpp::CardInfo.query({
        :app => get_app_id,
        :bank_account => '6222280012469823'
      })

      assert card_info.card_bin == '622228'
      assert card_info.app == get_app_id
      assert card_info.card_type == 2
      assert card_info.open_bank_code == '0310'
    end
  end
end
