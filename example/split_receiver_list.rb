require "pingpp"

# 查询分账接收方列表

API_KEY = "sk_test_ibbTe5jLGCi5rzfH4OqPW9KC"
# 设置 API Key
Pingpp.api_key = API_KEY
Pingpp.private_key_path = File.dirname(__FILE__) + '/your_rsa_private_key.pem'

=begin
同时指定 type, channel, account 三个参数，可特定到一个分账接收方。
测试模式下，不同的 channel（都是微信，不区分 app、公众号、扫码等）效果一样
=end
recvs = Pingpp::SplitReceiver.list(
  :app => 'app_1Gqj58ynP0mHeX1q',
  :per_page => 3,
  :page => 1,
  :type => 'MERCHANT_ID', # 分账接收方账号类型
  :channel => 'wx_pub', # 渠道
  :account => '190001001', # 分账接收方账号
)
puts recvs
