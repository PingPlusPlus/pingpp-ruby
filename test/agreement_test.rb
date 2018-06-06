require File.expand_path('../test_assistant', __FILE__)

module Pingpp
  class AgreementTest < Test::Unit::TestCase
    should "execute should return a agreement list when passed correct parameters" do
      l = Pingpp::Agreement.list(
        :app => get_app_id,
        :per_page => 3
      )

      assert l.object == 'list'
      assert l.data.count <= 3
    end

    should "execute should return an exist agreement when passed correct agreement id" do
      agr_id = get_agreement_id
      c = Pingpp::Agreement.retrieve(agr_id)

      assert c.object == 'agreement'
      assert c.id == agr_id
    end

    should "execute should return an canceled agreement" do
      begin
        agr_id = get_agreement_id
        o = Pingpp::Agreement.cancel(agr_id)

        assert o.id == agr_id
        assert o.status == 'canceled'
      rescue => e
        assert e.kind_of?(Pingpp::InvalidRequestError)
        assert e.message.include?("该签约对象不能被更新状态")
      end
    end
  end
end
