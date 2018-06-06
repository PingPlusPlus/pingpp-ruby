require 'pingpp'

# 获取小程序的 openid
openid, error = Pingpp::WxLiteOauth.get_openid(
  '<WX_LITE_APP_ID>',
  '<WX_LITE_APP_SECRET>',
  '<CODE>'
)

# 获取小程序的 openid 和 sesion_key
res = Pingpp::WxLiteOauth.get_session(
  '<WX_LITE_APP_ID>',
  '<WX_LITE_APP_SECRET>',
  '<CODE>'
)
# res 包含 openid 和 session_key
