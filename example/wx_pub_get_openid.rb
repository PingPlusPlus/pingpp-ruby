require 'webrick'
require 'pingpp'

class Oauth < WEBrick::HTTPServlet::AbstractServlet
  def do_GET(request, response)
    url = Pingpp::WxPubOauth.create_oauth_url_for_code('WX-APP-ID', 'REDIRECT-URL')
    response.status = 302
    response['Location'] = url
  end
end

class GetOpenid < WEBrick::HTTPServlet::AbstractServlet
  def do_GET(request, response)
    query = request.query
    openid = Pingpp::WxPubOauth.get_openid('WX-APP-ID', 'WX-APP-SECRET', query['code'])
    # pass openid to extra['openid'] and create a charge
  end
end

server = WEBrick::HTTPServer.new(:Port => 8000)
server.mount "/oauth", Oauth
server.mount "/getopenid", GetOpenid
trap "INT" do server.shutdown end
server.start