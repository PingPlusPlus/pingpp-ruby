=begin
  Ping++ Server SDK 说明：
  以下代码只是为了方便商户测试而提供的样例代码，商户可根据自己网站需求按照技术文档编写, 并非一定要使用该代码。
  接入企业付款流程参考开发者中心：https://www.pingxx.com/docs/server，文档可筛选后端语言和接入渠道。
  该代码仅供学习和研究 Ping++ SDK 使用，仅供参考。
=end
require "pingpp"

# api_key 获取方式：登录 [Dashboard](https://dashboard.pingxx.com) -> 点击管理平台右上角公司名称 -> 企业设置 -> Secret Key
API_KEY = "sk_test_ibbTe5jLGCi5rzfH4OqPW9KC"
# app_id 获取方式：登录 [Dashboard](https://dashboard.pingxx.com) -> 应用卡片下方
APP_ID = "app_1Gqj58ynP0mHeX1q"
# 设置 API key
Pingpp.api_key = API_KEY
Pingpp.api_base = 'https://apidev.afon.ninja'
Pingpp.private_key_path = File.dirname(__FILE__) + '/your_rsa_private_key.pem'

# 请求报关接口
trade_no = Digest::MD5.hexdigest(Time.now.to_i.to_s)[0,12]
params = {
  :app => APP_ID,
  :channel => 'upacp', # 支付使用的第三方支付渠道，取值范围："alipay"（支付宝 APP 支付）；"wx"（微信支付）和"upacp"（银联）,"applepay_upacp"（Apple Pay）。
  :trade_no => trade_no, # 商户报关订单号，8~20位。
  :customs_code => 'GUANGZHOU',
  :amount => 50000,
  :charge => 'ch_TanbTO9OmjP4TGW5a1j1mPiL',
  :transport_amount => 10,
  :is_split => true,
  :sub_order_no => '201612250200',
  :extra => {
    :pay_account => '8022112223344',
    :certif_type => '02',
    :customer_name => 'Name',
    :certif_id => 'ID_CARD_NUMBER',
    :tax_amount  => 10
  }
}

customs = Pingpp::Customs.create(params)
puts customs

customs_id = customs['id']

## 查询
customs = Pingpp::Customs.retrieve(customs_id)
puts customs
