=begin
  Ping++ Server SDK 说明：
  以下代码只是为了方便商户测试而提供的样例代码，商户可根据自己网站需求按照技术文档编写, 并非一定要使用该代码。
  接入支付流程参考开发者中心：https://www.pingxx.com/docs/server/charge ，文档可筛选后端语言和接入渠道。
  该代码仅供学习和研究 Ping++ SDK 使用，仅供参考。
=end
require "pingpp"
require_relative "./agreement_extra"

# api_key 获取方式：登录 [Dashboard](https://dashboard.pingxx.com) -> 点击管理平台右上角公司名称 -> 企业设置 -> Secret Key
API_KEY = "sk_test_ibbTe5jLGCi5rzfH4OqPW9KC"
# app_id 获取方式：登录 [Dashboard](https://dashboard.pingxx.com) -> 应用卡片下方
APP_ID = "app_1Gqj58ynP0mHeX1q"
# 设置 API key
Pingpp.api_key = API_KEY

=begin
  设置请求签名密钥，密钥对需要你自己用 openssl 工具生成，如何生成可以参考帮助中心：https://help.pingxx.com/article/123161；
  生成密钥后，需要在代码中设置请求签名的私钥(rsa_private_key.pem)；
  然后登录 [Dashboard](https://dashboard.pingxx.com)->点击右上角公司名称->开发信息->商户公钥（用于商户身份验证）
  将你的公钥复制粘贴进去并且保存->先启用 Test 模式进行测试->测试通过后启用 Live 模式
=end

# 设置你的私钥路径，用于请求的签名
Pingpp.private_key_path = "#{File.dirname(__FILE__)}/your_rsa_private_key.pem"

# 或者直接设置私钥字符串
# Pingpp.private_key = 'PEM 格式的私钥字符串'

channel = "qpay" # 支付使用的第三方支付渠道取值

# 签约协议号
contract_no = Time.now.to_i.to_s[0,12]

agr = Pingpp::Agreement.create(
  :contract_no => contract_no, # 签约协议号
  :app => APP_ID,
  :channel => channel, # 签约渠道
  :metadata => {}, # metadata 元数据
  :extra => AgreementExtra.send(channel) # 对应各渠道的取值规则请查看 agreement_extra 相应方法内说明
)
puts agr
