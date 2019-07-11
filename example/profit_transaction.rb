require "pingpp"

# 分账明细

API_KEY = "sk_test_ibbTe5jLGCi5rzfH4OqPW9KC"
# 设置 API Key
Pingpp.api_key = API_KEY
Pingpp.private_key_path = File.dirname(__FILE__) + '/your_rsa_private_key.pem'

# 列表查询

txns = Pingpp::ProfitTransaction.list(
  :app => 'app_1Gqj58ynP0mHeX1q',
  :per_page => 3,
  :page => 1,
)
puts txns

# 单个查询

puts Pingpp::ProfitTransaction.retrieve('ptxn_1m3xtoBMRqu2qC')
