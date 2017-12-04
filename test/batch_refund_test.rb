require File.expand_path('../test_assistant', __FILE__)
require "digest/md5"

module Pingpp
  class BatchRefundTest < Test::Unit::TestCase
    should "execute should return a new batch_refund when passed correct parameters" do
      batch_no = Digest::MD5.hexdigest(Time.now.to_i.to_s)[0,12]

      params = {
        :app => get_app_id,
        :batch_no => batch_no,
        :charges => make_charges_for_batch_refund,
        :description => 'This is a batch_refund test.',
        :metadata => {
          :custom_key => 'custom_content'
        }
      }

      batre = Pingpp::BatchRefund.create(params)
      assert batre.object == 'batch_refund'

      assert batre.charges == params[:charges]
      assert batre.batch_no = params[:batch_no]
    end

    should "execute should return a batch_refund list" do
      batres = Pingpp::BatchRefund.list(:per_page => 3)

      assert batres.object == 'list'
      assert batres.url.start_with?('/v1/batch_refunds')
      assert batres.data.length <= 3
    end

    should "execute should return an exist batch_refund when passed correct id" do
      batre = Pingpp::BatchRefund.retrieve(get_bat_re_id)

      assert batre.id == get_bat_re_id
      assert batre.object == 'batch_refund'
    end
  end
end
