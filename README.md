Pingpp Ruby SDK 
=================

****

## 简介

lib 文件夹下是 Ruby SDK 文件，<br>
example 文件夹里面是一个简单的接入示例，该示例仅供参考。

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

发起支付请求示例：

```ruby
require "pingpp"

Pingpp.api_key = "YOUR-KEY"
Pingpp::Charge.create(
  :subject  => "Charge Subject",
  :body     => "Charge Body",
  :amount   => 100,
  :order_no => "orderNo",
  :channel  => Pingpp::Channel::ALIPAY,
  :client_ip=> '127.0.0.1',
  :app => {'id' => "YOUR-APP-ID"}
)
```

详细使用方法请参考 [技术文档](https://pingplusplus.com/document) 或者参考 [example](https://github.com/PingPlusPlus/pingpp-ruby/tree/master/example) 文件夹里的示例。
