=begin
  Ping++ Server SDK 说明：
  以下代码只是为了方便商户测试而提供的样例代码，商户可根据自己网站需求按照技术文档编写, 并非一定要使用该代码。
  接入企业付款流程参考开发者中心：https://www.pingxx.com/docs/server，文档可筛选后端语言和接入渠道。
  该代码仅供学习和研究 Ping++ SDK 使用，仅供参考。
=end
require "pingpp"
require_relative "./batch_transfer_recipient"

# api_key 获取方式：登录 [Dashboard](https://dashboard.pingxx.com) -> 点击管理平台右上角公司名称 -> 企业设置 -> Secret Key
API_KEY = "sk_test_ibbTe5jLGCi5rzfH4OqPW9KC"
# app_id 获取方式：登录 [Dashboard](https://dashboard.pingxx.com) -> 应用卡片下方
APP_ID = "app_1Gqj58ynP0mHeX1q"

# 设置 API key
Pingpp.api_key = API_KEY
Pingpp.private_key_path = "#{File.dirname(__FILE__)}/your_rsa_private_key.pem"

# 创建 batch_transfer

channel = "alipay"

batch_no = "#{Time.now.to_i.to_s}#{rand(9999).to_s.rjust(4, "0")}"
params = {
  :app => APP_ID,
  :batch_no => batch_no, # 批量企业付款批次号，3-24位，允许字母和英文。
  :channel => channel, # 渠道，目前支持 alipay、 unionpay、wx_pub、allinpay、jdpay
  :amount => 5000, # 订单总金额, 人民币单位：分（如订单总金额为 1 元，此处请填 100）
  :type => 'b2c', # 付款类型，转账到个人用户为 b2c，转账到企业用户为 b2b（微信公众号 wx_pub 的企业付款，仅支持 b2c）。
  :description => 'This is a batch_transfer test.',
  :metadata => {
    :custom_key => 'custom_content'
  },
  :currency => 'cny',
  :recipients => [ # 接收者信息，请参考 batch_transfer_recipient 内各渠道相应方法内说明，详见 https://www.pingxx.com/api#创建-batch-transfer-对象
    BatchTransferRecipient.send(channel),
    # 添加多个 recipient
  ]
}

batch_transfer = Pingpp::BatchTransfer.create(params)
puts batch_transfer
