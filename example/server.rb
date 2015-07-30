require 'webrick'
require 'json'
require 'digest/md5'
require 'pingpp'

# 配置 API Key 和 App ID #
# 从 Ping++ 管理平台应用信息里获取 #
API_KEY = 'sk_test_ibbTe5jLGCi5rzfH4OqPW9KC' # 这里填入你的 Test/Live Key
APP_ID = 'app_1Gqj58ynP0mHeX1q' # 这里填入你的应用 ID

# 创建 charge
class Pay < WEBrick::HTTPServlet::AbstractServlet
  def do_POST(request, response)
    Pingpp.api_key = API_KEY
    Pingpp.parse_headers(request.header)
    begin
      post_data = JSON.parse(request.body)
    rescue JSON::ParserError
      post_data = request.query
    end
    channel = post_data['channel'].downcase
    amount = post_data['amount']
    open_id = post_data['open_id'] # 微信公众号时
    client_ip = request.remote_ip
    extra = {}
    case channel
    when 'alipay_wap'
      extra = {
        'success_url' => 'http://www.yourdomain.com/success',
        'cancel_url'  => 'http://www.yourdomain.com/cancel'
      }
    when 'upacp_wap', 'upmp_wap'
      extra = {
        'result_url' => 'http://www.yourdomain.com/result?code='
      }
    when 'bfb_wap'
      extra = {
        'bfb_login' => true,
        'result_url' => 'http://www.yourdomain.com/success'
      }
    when 'wx_pub'
      extra = {
        'open_id' => open_id
      }
    end
    # 商户系统自己生成的订单号。如果是【壹收款】，则使用客户端传上来的 'order_no'。
    order_no = Digest::MD5.hexdigest(Time.now.to_i.to_s)[0,12]
    response_body = ''
    begin
      ch = Pingpp::Charge.create(
        :order_no  => order_no,
        :app       => {:id => APP_ID},
        :channel   => channel,
        :amount    => amount,
        :client_ip => client_ip,
        :currency  => 'cny',
        :subject   => 'Charge Subject',
        :body      => 'Charge Body',
        :extra     => extra
      )
      response_body = ch.to_json
    rescue Pingpp::PingppError => error
      response_body = error.http_body
    end
    response.status = 200
    response['Content-Type'] = 'application/json'
    response.body = response_body
  end
end

server = WEBrick::HTTPServer.new(:Port => 8000)
server.mount '/pay', Pay
trap 'INT' do server.shutdown end
server.start