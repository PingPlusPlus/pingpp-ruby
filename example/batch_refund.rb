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

# 创建 batch_refund
batch_no = Digest::MD5.hexdigest(Time.now.to_i.to_s)[0,12]
params = {
  :app => APP_ID,
  :batch_no => batch_no, # 批量退款批次号，3-24位，允许字母和英文。
  :charges => [
    'ch_bT0eDKO8K0q9j5yLCC5G4az1',
    'ch_qPGC04zjrT4KHWzTq5OiPu5G',
    'ch_9OS0SKDiP0GS5qH8eH5GavzH'
  ],
  :description  => 'This is a batch_refund test.',
  :metadata => {
    :custom_key => 'custom_content'
  }
}

batch_refund = Pingpp::BatchRefund.create(params)
puts batch_refund

bat_re_id = batch_refund['id']

## 查询
batch_refund = Pingpp::BatchRefund.retrieve(bat_re_id)
puts batch_refund

## 查询列表
batch_refunds = Pingpp::BatchRefund.list(:app => APP_ID, :per_page => 3)
puts batch_refunds
