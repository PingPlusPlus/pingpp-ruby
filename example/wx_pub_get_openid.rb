require 'webrick'
require 'pingpp'

# 跳转到微信进行认证
class Oauth < WEBrick::HTTPServlet::AbstractServlet
  def do_GET(request, response)
    url = Pingpp::WxPubOauth.create_oauth_url_for_code('WX-PUB-APP-ID', 'http://example.com/getopenid?showwxpaytitle=1')
    response.status = 302
    response['Location'] = url
  end
end

# 回调地址，获取 openid
class GetOpenid < WEBrick::HTTPServlet::AbstractServlet
  def do_GET(request, response)
    query = request.query
    openid, error = Pingpp::WxPubOauth.get_openid('WX-PUB-APP-ID', 'WX-PUB-APP-SECRET', query['code'])
    # ...
    # pass openid to extra['open_id'] and create a charge
    # ...
  end
end

server = WEBrick::HTTPServer.new(:Port => 80)
server.mount "/oauth", Oauth
server.mount "/getopenid", GetOpenid
trap "INT" do server.shutdown end
server.start