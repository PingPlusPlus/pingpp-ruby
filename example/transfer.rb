require "pingpp"

# 配置 API Key 和 App ID #
# 从 Ping++ 管理平台应用信息里获取 #
API_KEY = "sk_test_ibbTe5jLGCi5rzfH4OqPW9KC" # 这里填入你的 Test/Live Key
APP_ID = "app_1Gqj58ynP0mHeX1q" # 这里填入你的应用 ID

Pingpp.api_key = API_KEY

# 企业付款
## 创建
transfer = Pingpp::Transfer.create(
  :order_no    => Time.now.to_i.to_s,
  :app         => { :id => APP_ID },
  :channel     => "wx_pub",
  :amount      => 100,
  :currency    => "cny",
  :type        => "b2c",
  :recipient   => "Openid",
  :description => "Your Description"
)
puts transfer

## 查询
transfer = Pingpp::Transfer.retrieve("tr_Hm5uDSH8qP8OvbrT0GfDOerP")
puts transfer

## 查询列表
transfers = Pingpp::Transfer.all(:limit => 5)
puts transfers
