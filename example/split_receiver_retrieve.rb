require "pingpp"

# 查询单个分账接收方

API_KEY = "sk_test_ibbTe5jLGCi5rzfH4OqPW9KC"
# 设置 API Key
Pingpp.api_key = API_KEY
Pingpp.private_key_path = File.dirname(__FILE__) + '/your_rsa_private_key.pem'

puts Pingpp::SplitReceiver.retrieve('recv_1fRcbVfT2Vwcya')
