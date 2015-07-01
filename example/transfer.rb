require "pingpp"

Pingpp.api_key = "YOUR-KEY"

# 企业付款
## 创建
transfer = Pingpp::Transfer.create(
  :order_no    => "123456789",
  :app         => { :id => "APP_ID" },
  :channel     => "wx_pub",
  :amount      => 100,
  :currency    => "cny",
  :type        => "b2c",
  :recipient   => "Openid",
  :description => "Your Description"
)

## 查询
transfer = Pingpp::Transfer.retrieve("TRANSFER_ID")

## 查询列表
transfers = Pingpp::Transfer.all(:limit => 5)
