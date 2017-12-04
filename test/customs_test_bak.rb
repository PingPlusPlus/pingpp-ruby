require File.expand_path('../test_assistant', __FILE__)
require "digest/md5"

module Pingpp
  class CustomsTest < Test::Unit::TestCase
    should "execute should return a new customs when passed correct parameters" do
      order_no = Digest::MD5.hexdigest(Time.now.to_i.to_s)[0,12]
      channel = 'upacp'

      params = {
        :app => get_app_id,
        :charge => get_charge_id,
        :channel => channel,
        :trade_no => order_no,
        :customs_code => 'GUANGZHOU',
        :amount => 10,
        :transport_amount => 1,
        :is_split => true,
        :sub_order_no => 'subord11010002',
        :extra => {
          :pay_account => '1234567890',
          :certif_type => '02',
          :customer_name => 'name',
          :certif_id => '1234',
          :tax_amount => 1
        }
      }
      cu = Pingpp::Customs.create(params)
    end
  end
end
