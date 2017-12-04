require 'pingpp'
require 'test/unit'
require 'mocha/setup'
require 'stringio'
require 'shoulda/context'
require File.expand_path('../test_data', __FILE__)

module Pingpp
  @mock_rest_client = nil

  def self.mock_rest_client=(mock_client)
    @mock_rest_client = mock_client
  end
end

class Test::Unit::TestCase
  include Pingpp::TestData
  include Mocha

  setup do
    @mock = mock
    Pingpp.mock_rest_client = @mock
    Pingpp.api_key = get_api_key

    Pingpp.private_key_path = File.expand_path('../../example/your_rsa_private_key.pem', __FILE__)

    # 使用账户系统部分接口需要设置该参数，调用相关方法时可传 opts[:app] 参数来覆盖该值
    Pingpp.app_id = get_app_id
  end

  teardown do
    Pingpp.mock_rest_client = nil
    Pingpp.api_key = nil
  end
end
