require "pingpp"

# api_key 获取方式：登录 [Dashboard](https://dashboard.pingxx.com) -> 点击管理平台右上角公司名称 -> 企业设置 -> Secret Key
API_KEY = "sk_test_ibbTe5jLGCi5rzfH4OqPW9KC"
# app_id 获取方式：登录 [Dashboard](https://dashboard.pingxx.com) -> 应用卡片下方
APP_ID = "app_1Gqj58ynP0mHeX1q"
# 设置 API key
Pingpp.api_key = API_KEY
Pingpp.private_key_path = "#{File.dirname(__FILE__)}/your_rsa_private_key.pem"

## 取消 Transfer（仅限 unionpay 渠道）
transfers = Pingpp::Transfer.cancel(
    "tr_uHWX58DanDOGCKOynHvPirfT"
)
puts transfers
