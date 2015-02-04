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
关于如何使用 SDK 请参考 [技术文档](https://pingxx.com/document) 或者参考 [example](https://github.com/PingPlusPlus/pingpp-ruby/tree/master/example) 文件夹里的示例。

## 更新日志
### 2.0.1
* 更改：<br>
传递客户端的请求头部到 API

### 2.0.0
* 更改：<br>
添加新渠道：百付宝、百付宝WAP、微信公众号

### 1.0.3
* 更改：<br>
移除旧的 refund 方法
