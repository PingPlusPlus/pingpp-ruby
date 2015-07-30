require "pingpp"

# 配置 API Key 和 App ID #
# 从 Ping++ 管理平台应用信息里获取 #
API_KEY = "sk_test_ibbTe5jLGCi5rzfH4OqPW9KC" # 这里填入你的 Test/Live Key
Pingpp.api_key = API_KEY

ch = Pingpp::Charge.retrieve("ch_bLWP80Ci9S4ODaXLSKLOGe5S")
re = ch.refunds.create(:description => "Refund Description", :amount => 1)
puts re