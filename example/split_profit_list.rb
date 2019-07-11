require "pingpp"

# 查询分账列表

API_KEY = "sk_test_ibbTe5jLGCi5rzfH4OqPW9KC"
# 设置 API Key
Pingpp.api_key = API_KEY
Pingpp.private_key_path = File.dirname(__FILE__) + '/your_rsa_private_key.pem'

sps = Pingpp::SplitProfit.list(
  :app => 'app_1Gqj58ynP0mHeX1q',
  :per_page => 3,
  :page => 1,
  # :type => 'split_normal', # 分账类型
  # :channel => 'wx_pub_qr', # 渠道
)
puts sps
