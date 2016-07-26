=begin
  Ping++ Server SDK 说明：
  以下代码只是为了方便商户测试而提供的样例代码，商户可根据自己网站需求按照技术文档编写, 并非一定要使用该代码。
  接入企业付款流程参考开发者中心：https://www.pingxx.com/docs/server/transfer ，文档可筛选后端语言和接入渠道。
  该代码仅供学习和研究 Ping++ SDK 使用，仅供参考。
=end
require "pingpp"

# api_key 获取方式：登录 [Dashboard](https://dashboard.pingxx.com)->点击管理平台右上角公司名称->开发信息-> Secret Key
API_KEY = "sk_test_ibbTe5jLGCi5rzfH4OqPW9KC"
# app_id 获取方式：登录 [Dashboard](https://dashboard.pingxx.com)->点击你创建的应用->应用首页->应用 ID(App ID)
APP_ID = "app_1Gqj58ynP0mHeX1q"
# 设置 API key
Pingpp.api_key = API_KEY
# 设置你的私钥路径，用于请求的签名
Pingpp.private_key_path = File.dirname(__FILE__) + '/your_rsa_private_key.pem'

# 调用身份证认证接口
result = Pingpp::Identification.identify(
  :type => "id_card",
  :app  => APP_ID,
  :data => {
      :id_name => "张三", # 姓名
      :id_number => "310181198910107641" # 身份证号
  }
)
puts result

# 调用银行卡认证接口
result = Pingpp::Identification.identify(
  :type  => "bank_card",
  :app  => APP_ID,
  :data => {
      :id_name => "张三", # 姓名
      :id_number => "310181198910107641", # 身份证号
      :card_number => "6201111122223333", # 银行卡号
      :phone_number => "18623234545" # 银行预留手机号，不支持 178 号段
  }
)
puts result
