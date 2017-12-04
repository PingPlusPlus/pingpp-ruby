require File.expand_path('../test_assistant', __FILE__)
require "digest/md5"

module Pingpp
  class BatchTransferTest < Test::Unit::TestCase
    should "execute should return a new batch_transfer when passed correct parameters" do
      batch_no = Digest::MD5.hexdigest(Time.now.to_i.to_s)[0,12]

      params = {
        :app => get_app_id,
        :batch_no => batch_no,
        :channel => 'alipay',
        :amount => 1000,
        :type => 'b2c',
        :description => 'This is a batch_transfer test.',
        :metadata => {
          :custom_key => 'custom_content'
        },
        :currency => 'cny',
        :recipients => [
          {
            :account => 'account01@gmail.com',
            :amount => 300,
            :name => 'name01'
          }, {
            :account => 'account02@gmail.com',
            :amount => 300,
            :name => 'name02'
          }, {
            :account => 'account03@gmail.com',
            :amount => 400,
            :name => 'name03'
          }
        ]
      }

      battr = Pingpp::BatchTransfer.create(params)

      assert battr.object == 'batch_transfer'
      assert battr.amount == params[:amount]
      assert battr.batch_no = params[:batch_no]
      assert battr.app == params[:app]
      assert battr.recipients.count == params[:recipients].count
    end

    should "execute should return a batch_transfer list" do
      batres = Pingpp::BatchTransfer.list(:per_page => 3)

      assert batres.object == 'list'
      assert batres.url.start_with?('/v1/batch_transfers')
      assert batres.data.count <= 3
    end

    should "execute should return an exist batch_transfer when passed correct id" do
      batre = Pingpp::BatchTransfer.retrieve(get_bat_tr_id)

      assert batre.id == get_bat_tr_id
      assert batre.object == 'batch_transfer'
    end
  end
end
