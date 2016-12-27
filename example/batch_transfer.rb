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
Pingpp.private_key_path = File.dirname(__FILE__) + '/your_rsa_private_key.pem'

# 创建 batch_transfer
batch_no = Digest::MD5.hexdigest(Time.now.to_i.to_s)[0,12]
params = {
  :app => APP_ID,
  :batch_no => batch_no, # 批量企业付款批次号，3-24位，允许字母和英文。
  :channel => 'unionpay', # 渠道参数，目前支持 alipay（支付宝）和 unionpay（企业付款到银行卡）。
  :amount => 700, # 订单总金额, 人民币单位：分（如订单总金额为 1 元，此处请填 100）
  :type => 'b2c', # 付款类型，当前仅支持 b2c 企业付款
  :description => 'This is a batch_transfer test.',
  :metadata => {
    :custom_key => 'custom_content'
  },
  :currency => 'cny',
  :recipients => [ # 接收者信息，详见 https://www.pingxx.com/api#创建-batch-transfer-对象
    {
      :amount => 300,
      :name => 'name01',
      :open_bank_code => '0102',
      :account => '6226000022223333'
    }, {
      :amount => 400,
      :name => 'name02',
      :open_bank_code => '0102',
      :account => '6226000022223334'
    }
  ]
}

batch_transfer = Pingpp::BatchTransfer.create(params)
puts batch_transfer

bat_tr_id = batch_transfer['id']

## 查询
batch_transfer = Pingpp::BatchTransfer.retrieve(bat_tr_id)
puts batch_transfer

## 查询列表
batch_transfers = Pingpp::BatchTransfer.list(:app => APP_ID, :per_page => 3)
puts batch_transfers

## 取消 Transfer（仅限 unionpay 渠道）
batch_transfer = Pingpp::BatchTransfer.cancel(
    bat_tr_id
)
puts batch_transfer
