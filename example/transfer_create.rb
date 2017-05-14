=begin
  Ping++ Server SDK 说明：
  以下代码只是为了方便商户测试而提供的样例代码，商户可根据自己网站需求按照技术文档编写, 并非一定要使用该代码。
  接入企业付款流程参考开发者中心：https://www.pingxx.com/docs/server/transfer ，文档可筛选后端语言和接入渠道。
  该代码仅供学习和研究 Ping++ SDK 使用，仅供参考。
=end
require "pingpp"
require_relative "./transfer_extra"

# api_key 获取方式：登录 [Dashboard](https://dashboard.pingxx.com) -> 点击管理平台右上角公司名称 -> 企业设置 -> Secret Key
API_KEY = "sk_test_ibbTe5jLGCi5rzfH4OqPW9KC"
# app_id 获取方式：登录 [Dashboard](https://dashboard.pingxx.com) -> 应用卡片下方
APP_ID = "app_1Gqj58ynP0mHeX1q"

# 设置 API key
Pingpp.api_key = API_KEY
Pingpp.private_key_path = "#{File.dirname(__FILE__)}/your_rsa_private_key.pem"

# 创建 Transfer
channel = "wx_pub"

# 付款使用的商户内部订单号。
# wx_pub 规定为 1 ~ 50 位不能重复的数字字母组合;
# alipay 为 1 ~ 64 位不能重复的数字字母组合;
# unionpay 为 1 ~ 16 位的纯数字;
# jdpay 限长 1 ~ 64 位不能重复的数字字母组合;
# allinpay 限长 20 ~ 40 位不能重复的数字字母组合，必须以签约的通联的商户号开头（建议组合格式：通联商户号 + 时间戳 + 固定位数顺序流水号，不包含+号）
if channel == "allinpay"
  order_no = "301002#{Time.now.to_i.to_s}#{rand(999999).to_s.rjust(6, "0")}"
else
  order_no = "#{Time.now.to_i.to_s}#{rand(9999).to_s.rjust(4, "0")}"
end

recipient, extra = TransferExtra.send(channel)

transfer = Pingpp::Transfer.create(
  :order_no    => order_no,
  :app         => { :id => APP_ID },
  :channel     => channel, # 目前支持 支付宝：alipay，银联：unionpay，微信公众号：wx_pub，通联：allinpay，京东：jdpay
  :amount      => 100, # 付款金额，相关渠道的限额，请查看 https://help.pingxx.com/article/133366/ 。单位为对应币种的最小货币单位，例如：人民币为分。
  :currency    => "cny",
  :type        => "b2c", # 付款类型，转账到个人用户为 b2c，转账到企业用户为 b2b（微信公众号 wx_pub 的企业付款，仅支持 b2c）。
  :recipient   => recipient, # 接收者，请查看 transfer_extra 相应方法内说明
  :description => "Your Description",
  :extra       => extra # 对应各渠道的取值规则请查看 transfer_extra 相应方法内说明
)
puts transfer
