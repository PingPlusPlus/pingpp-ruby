# ChangeLog

## 2.2.4

- 新增: `sub_bank`, `split_proft`, `split_receiver`, `profit_transaction` 相关接口

---

## 2.2.3

#### 修改

- 去除指定 ssl_version
- 更新 CA 证书

## 2.2.2
#### 新增
- 自定义 CA 证书路径
- 添加余额结算接口 (BalanceSettlement)
- 添加银行卡信息查询接口 (CardInfo)
- 添加签约接口 (Agreement)
- 添加微信小程序获取 openid 和 session_key 方法
    - `Pingpp::WxLiteOauth.get_openid`
    - `Pingpp::WxLiteOauth.get_session`

## 2.2.1 (2018-01-05)
#### 更改
- 去除转账、批量转账取消接口

## 2.2.0 (2017-12-01)
#### 更改
- 合并账户系统相关接口

## 2.1.7 (2017-10-20)
#### 更改
- 自动重试机制

## 2.1.4 (2017-08-01)
#### 修正
- delete 接口修正

## 2.1.3 (2017-06-20)
#### 新增
- 增加 isv_scan, isv_qr, isv_wap 渠道撤销接口

## 2.1.1 (2016-12-27)
#### 新增
- 批量付款取消接口

## 2.1.0
#### 新增
- 批量付款接口
- 批量退款接口
- 报关接口
- 添加 rate_limit_error

#### 更改
- 签名生成方式更改，加入请求时间戳和 URI
- 移除 event list 接口
- 更新 ca 证书

## 2.0.14
#### 新增
- 添加 Identification 接口

## 2.0.13
#### 新增
- 添加 webhooks 验证方法

## 2.0.12
#### 修改
- 允许用字符串方式设置私钥，而非私钥路径 `Pingpp.private_key = 'PRIVATE KEY CONTENTS'`

## 2.0.9
#### 新增
- 添加请求签名

#### 修改
- 更新本地 CA 证书

## 2.0.8
#### 修改
- 补充 channel_error 错误类型

## 2.0.7
#### 增加
- 增加 Transfer 接口

## 2.0.6
#### 更改
- 兼容微信公众号 credential 内 timeStamp 字段为整型的情况

## 2.0.5
#### 增加
- 增加 Event 接口

## 2.0.4
#### 增加
- 增加微信公众号获取 JS-SDK 签名的接口

## 2.0.3
#### 更改
- 微信公众号获取 openid 失败时，返回错误信息

## 2.0.2
#### 新增
- 新增微信红包

#### 更改
- 移除 channel.rb

## 2.0.1
#### 更改
- 传递客户端的请求头部到 API

## 2.0.0
#### 更改
- 添加新渠道：百付宝、百付宝WAP、微信公众号

## 1.0.3
#### 更改
- 移除旧的 refund 方法
