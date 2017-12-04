require File.expand_path('../test_assistant', __FILE__)

module Pingpp
  class RoyaltyTest < Test::Unit::TestCase
    # 批量更新分润对象
    should "return a royalty list object when passed correct ids" do
      params = {
        # 分润 ID 列表  required|array
        :ids => get_royalty_ids_to_update,

        # 描述信息  optional|string
        :description => "DESCRIPTION",

        #   optional|string
        # :method => "manual",
      }

      o = Pingpp::Royalty.batch_update(params)

      assert o.kind_of?(Pingpp::ListObject)
      assert o.data[0].kind_of?(Pingpp::Royalty)
    end

    # 查询分润对象
    should "return an existed royalty object when passed a correct id" do
      o = Pingpp::Royalty.retrieve(existed_royalty_id)

      assert o.kind_of?(Pingpp::Royalty)
    end

    # 查询分润对象列表
    should "return a list object of royalties" do
      o = Pingpp::Royalty.list(
        { :per_page => 3, :page => 1 }
      )

      assert o.kind_of?(Pingpp::ListObject)
      if o.data.count > 0
        assert o.data[0].kind_of?(Pingpp::Royalty)
      end
    end
  end
end
