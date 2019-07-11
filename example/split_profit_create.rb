require "pingpp"
require "digest"

# 创建分账接收方

API_KEY = "sk_test_ibbTe5jLGCi5rzfH4OqPW9KC"
# 设置 API Key
Pingpp.api_key = API_KEY
Pingpp.private_key_path = File.dirname(__FILE__) + '/your_rsa_private_key.pem'

order_no = Digest.hexencode(Random::DEFAULT.bytes(8))
sp = Pingpp::SplitProfit.create(
  :app => 'app_1Gqj58ynP0mHeX1q',
  :charge => 'ch_SyzLa9r1W9K85O44yDOq1CuD', # Ping++ 交易成功的 charge ID
  :order_no => order_no, # 分账单号，由商家自行生成
  :type => 'split_normal', # 分账类型: split_normal 为单次分账, split_return 为完结分账, split_multi 为多次分账。
  :recipients => [ # 分账接收列表
    {
      :split_receiver => 'recv_1fRcbVfT2Vwcya', # 分账接收方 ID
      :amount => 10, # 分账金额
      :name => '示例商户全称', # 可选。分账接收方姓名，如果商家传递该字段则 Ping++ 会校验 name 与 split_receiver 是否对应。
      :description => '分账给商户', # 分账描述（不支持特殊字符 & ）
    },
  ],
  :metadata => {
    :custom_key => 'custom_value',
  },
)
puts sp
