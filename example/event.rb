require "pingpp"

# api_key 获取方式：登录 [Dashboard](https://dashboard.pingxx.com)->点击管理平台右上角公司名称->开发信息-> Secret Key
API_KEY = "sk_test_ibbTe5jLGCi5rzfH4OqPW9KC"
# 设置 API Key
Pingpp.api_key = API_KEY

# retrieve an event
evt = Pingpp::Event.retrieve("evt_VzWdLFbm5D6OdOuzQv7oqF0X")
puts evt

# list all events
evts = Pingpp::Event.all(:limit => 3)
puts evts
