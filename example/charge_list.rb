require "pingpp"

# API Key 获取方式：登录 [Dashboard](https://dashboard.pingxx.com)
#       -> 点击管理平台右上角公司名称 -> 企业设置 -> Secret Key

API_KEY = "sk_test_ibbTe5jLGCi5rzfH4OqPW9KC"
# 设置 API Key
Pingpp.api_key = API_KEY
Pingpp.private_key_path = File.dirname(__FILE__) + '/your_rsa_private_key.pem'

chs = Pingpp::Charge.list(
  :app => {:id => 'app_1Gqj58ynP0mHeX1q'}, # 请加上 app[id] 参数
  :limit => 5,
  :paid => true,
  :refunded => false,
  :channel => 'alipay'
)
puts chs
