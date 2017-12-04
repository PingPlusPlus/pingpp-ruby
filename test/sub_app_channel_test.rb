require File.expand_path('../test_assistant', __FILE__)

module Pingpp
  class SubAppChannelTest < Test::Unit::TestCase
    # 创建子商户渠道参数 (仅支持 livemode)
    should "sub_app channel create" do
      params = {
        :channel => "bfb",
        :params => {
          "fee_rate" => 60,
          "bfb_sp" => "1600330402",
          "bfb_key" => "c832cGsdBdErycpTxs3KMQ3cQkawZvzC"
        },
        :description => "channel info"
      }

      channel_info = Pingpp::Channel.create(params, {:sub_app => get_sub_app_id})

      assert channel_info.object == 'channel'
      assert channel_info.description == params[:description]
      assert channel_info.params['fee_rate'] == params[:params]["fee_date"]
      assert channel_info.params['bfb_sp'] == params[:params]["bfb_sp"]
      assert channel_info.params['bfb_key'] == params[:params]["bfb_key"]
    end

    # 查询子商户渠道参数 (仅支持 livemode)
    should "sub_app channel retrieve" do
      channel_info = Pingpp::Channel.retrieve(
        "bfb",
        {
          :sub_app => get_sub_app_id
        }
      )

      assert channel_info.object == 'channel'
    end

    # 更新子商户渠道参数 (仅支持 livemode)
    should "sub_app channel update" do
      new_description = 'Shanghai ' + Time.now.iso8601
      channel_info = Pingpp::Channel.update(
        "bfb",
        {
          :description => new_description,
          :params => {
            "fee_rate" => 60,
            "bfb_sp" => "1600330404",
            "bfb_key" => "c832cGscpTxs3KMQ3cQkdBdEryawZvzC"
          }
        },
        { :sub_app => get_sub_app_id }
      )

      assert channel_info.object == 'channel'
      assert channel_info.description == new_description
    end

    # 删除子商户渠道参数 (仅支持 livemode)
    should "sub_app channel delete" do
      channel_info = Pingpp::Channel.delete(
        "bfb",
        {}
        { :sub_app => get_sub_app_id }
      )

      assert o.deleted
      assert o.channel == "bfb"
    end
  end
end
