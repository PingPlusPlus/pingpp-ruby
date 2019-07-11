require "pingpp"

# 创建分账接收方

API_KEY = "sk_test_ibbTe5jLGCi5rzfH4OqPW9KC"
# 设置 API Key
Pingpp.api_key = API_KEY
Pingpp.private_key_path = File.dirname(__FILE__) + '/your_rsa_private_key.pem'

recv = Pingpp::SplitReceiver.create(
  :app => 'app_1Gqj58ynP0mHeX1q',
  :type => 'MERCHANT_ID', # 分账接收方类型。
                          # MERCHANT_ID：商户 ID，
                          # PERSONAL_WECHATID：个人微信号，
                          # PERSONAL_OPENID：个人 openid（由服务商 appid 获取得到），
                          # PERSONAL_SUB_OPENID: 个人 sub_openid（由特约子商户 appid 获取得到）
  :name => '示例商户全称', # 分账接收方全称
  :account => '190001002', # 分账接收方帐号
  :channel => 'wx_pub', # 创建分账接收方使用的渠道(参数)
)
puts recv
