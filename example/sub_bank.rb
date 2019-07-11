require "pingpp"

# 银行支行列表查询接口

API_KEY = "sk_test_ibbTe5jLGCi5rzfH4OqPW9KC"
# 设置 API Key
Pingpp.api_key = API_KEY
Pingpp.private_key_path = File.dirname(__FILE__) + '/your_rsa_private_key.pem'

sub_banks = Pingpp::SubBank.query(
  :app => 'app_1Gqj58ynP0mHeX1q',
  :open_bank_code => '0308', # 银行开户行编号
  :prov => '浙江省', # 省份
  :city => '宁波市', # 城市
  :channel => 'chanpay', # 相关 transfer 渠道
)
puts sub_banks
