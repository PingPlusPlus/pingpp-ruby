Pingpp Ruby SDK 
=================
****

## 简介
lib 文件夹下是 Ruby SDK 文件，<br>
example 文件夹里面是一个简单的接入示例，该示例仅供参考。

## 版本要求
Ruby 版本 1.8.7 及以上

## 安装
```
gem install pingpp
```
或者使用源码构建：
```
gem build pingpp.gemspec
gem install pingpp-<VERSION>.gem
```

## 接入方法
### 初始化
``` ruby
require "pingpp"
Pingpp.api_key = "YOUR-KEY"
```

### 支付
``` ruby
Pingpp::Charge.create(
  :order_no  => "123456789",
  :app       => { :id => "YOUR-APP-ID" },
  :channel   => channel,
  :amount    => 100,
  :client_ip => "127.0.0.1",
  :currency  => "cny",
  :subject   => "Charge Subject",
  :body      => "Charge Body"
)
```

### 查询
``` ruby
Pingpp::Charge.retrieve("CHARGE-ID")
```
``` ruby
Pingpp::Charge.all(:limit => 5)
```

### 退款
``` ruby
Pingpp::Charge.retrieve("CHARGE-ID").refunds.create(:description => "Refund Description")
```

### 退款查询
``` ruby
Pingpp::Charge.retrieve("CHARGE-ID").refunds.retrieve("REFUND-ID")
```
``` ruby
Pingpp::Charge.retrieve("CHARGE-ID").refunds.all(:limit => 5)
```

### 微信红包
``` ruby
Pingpp::RedEnvelope.create(
  :order_no    => "123456789",
  :app         => { :id => "YOUR-APP-ID" },
  :channel     => "wx_pub",
  :amount      => 100,
  :currency    => "cny",
  :subject     => "Your Subject",
  :body        => "Your Body",
  :extra       => {
    :nick_name => "Nick Name",
    :send_name => "Send Name"
  },
  :recipient   => "Openid",
  :description => "Your Description"
)
```

**详细信息请参考 [API 文档](https://pingxx.com/document/api?ruby)。**
