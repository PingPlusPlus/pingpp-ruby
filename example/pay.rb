require "pingpp"
require "digest/md5"

# 配置 API Key 和 App ID #
# 从 Ping++ 管理平台应用信息里获取 #
API_KEY = "sk_test_ibbTe5jLGCi5rzfH4OqPW9KC" # 这里填入你的 Test/Live Key
APP_ID = "app_1Gqj58ynP0mHeX1q" # 这里填入你的应用 ID

Pingpp.api_key = API_KEY

channel = "alipay" # 选择渠道
extra = {}
# 特定渠道发起交易时需要的额外参数 extra，下面以 alipay_wap 和 upacp_wap 为例
case channel
when "alipay_wap"
  extra = {
    :success_url => "http://www.yourdomain.com/success",
    :cancel_url  => "http://www.yourdomain.com/cancel"
  }
when "upacp_wap"
  extra = {
    :result_url => "http://www.yourdomain.com/result"
  }
end
orderNo = Digest::MD5.hexdigest(Time.now.to_i.to_s)[0,12]
# Pingpp.parse_headers(headers) # request headers
ch = Pingpp::Charge.create(
  :order_no  => orderNo,
  :app       => { :id => APP_ID },
  :channel   => channel,
  :amount    => 100,
  :client_ip => "127.0.0.1",
  :currency  => "cny",
  :subject   => "Your Subject",
  :body      => "Your Body",
  :extra     => extra
)
puts ch