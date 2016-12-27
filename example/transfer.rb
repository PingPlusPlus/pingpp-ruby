=begin
  Ping++ Server SDK 说明：
  以下代码只是为了方便商户测试而提供的样例代码，商户可根据自己网站需求按照技术文档编写, 并非一定要使用该代码。
  接入企业付款流程参考开发者中心：https://www.pingxx.com/docs/server/transfer ，文档可筛选后端语言和接入渠道。
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

# 创建 Transfer
transfer = Pingpp::Transfer.create(
  :order_no    => Time.now.to_i.to_s,
  :app         => { :id => APP_ID },
  :channel     => "wx_pub",# 目前支持 wx(新渠道)、 wx_pub
  :amount      => 100,# 订单总金额, 人民币单位：分（如订单总金额为 1 元，此处请填 100,企业付款最小发送金额为 1 元）
  :currency    => "cny",
  :type        => "b2c",# 付款类型，当前仅支持 b2c 企业付款
  :recipient   => "Openid",# 接收者 id， 为用户在 wx(新渠道)、wx_pub 下的 open_id
  :description => "Your Description"
)
puts transfer

## 查询
transfer = Pingpp::Transfer.retrieve("tr_Hm5uDSH8qP8OvbrT0GfDOerP")
puts transfer

## 查询列表
transfers = Pingpp::Transfer.list(:app => {:id => APP_ID}, :limit => 3)
puts transfers

## 取消 Transfer（仅限 unionpay 渠道）
transfers = Pingpp::Transfer.cancel(
    "tr_uHWX58DanDOGCKOynHvPirfT"
)
puts transfers
