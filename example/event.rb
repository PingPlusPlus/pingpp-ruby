require "pingpp"

# 配置 API Key 和 App ID #
# 从 Ping++ 管理平台应用信息里获取 #
API_KEY = "sk_test_ibbTe5jLGCi5rzfH4OqPW9KC" # 这里填入你的 Test/Live Key
Pingpp.api_key = API_KEY

# retrieve an event
evt = Pingpp::Event.retrieve("evt_VzWdLFbm5D6OdOuzQv7oqF0X")
puts evt

# list all events
evts = Pingpp::Event.all(:limit => 3)
puts evts