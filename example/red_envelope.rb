require "pingpp"

# 配置 API Key 和 App ID #
# 从 Ping++ 管理平台应用信息里获取 #
API_KEY = "sk_test_ibbTe5jLGCi5rzfH4OqPW9KC" # 这里填入你的 Test/Live Key
APP_ID = "app_1Gqj58ynP0mHeX1q" # 这里填入你的应用 ID

Pingpp.api_key = API_KEY

begin
  red = Pingpp::RedEnvelope.create(
    :order_no    => Time.now.to_i.to_s,
    :app         => { :id => APP_ID },
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

  puts red
rescue Pingpp::PingppError => e
  puts e
end
