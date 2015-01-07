require 'webrick'
require 'json'
require "digest/md5"
require 'pingpp'

class Pay < WEBrick::HTTPServlet::AbstractServlet
  def do_POST(request, response)
    Pingpp.api_key = "YOUR-KEY"
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
    when Pingpp::Channel::ALIPAY_WAP
      extra = {
        'success_url' => 'http://www.yourdomain.com/success',
        'cancel_url'  => 'http://www.yourdomain.com/cancel'
      }
    when Pingpp::Channel::UPMP_WAP, Pingpp::Channel::UPACP_WAP
      extra = {
        'result_url' => 'http://www.yourdomain.com/result?code='
      }
    when Pingpp::Channel::BFB_WAP
      extra = {
        'bfb_login' => true,
        'result_url' => 'http://www.yourdomain.com/success'
      }
    when Pingpp::Channel::WX_PUB
      extra = {
        'trade_type' => 'JSAPI',
        'open_id' => open_id
      }
    end
    # 商户系统自己生成的订单号。如果是【壹收款】，则使用客户端传上来的 'order_no'。
    order_no = Digest::MD5.hexdigest(Time.now.to_i.to_s)[0,12]
    response_body = ''
    begin
      ch = Pingpp::Charge.create(
        :order_no  => order_no,
        :app       => {'id' => "YOUR-APP-ID"},
        :channel   => channel,
        :amount    => amount,
        :client_ip => client_ip,
        :currency  => 'cny',
        :subject   => "Charge Subject",
        :body      => "Charge Body",
        :extra     => extra
      )
      response_body = ch.to_json
    rescue Pingpp::PingppError => error
      response_body = error.http_body
    end
    response.status = 200
    response['Content-Type'] = "application/json"
    response.body = response_body
  end
end

server = WEBrick::HTTPServer.new(:Port => 8000)
server.mount "/pay", Pay
trap "INT" do server.shutdown end
server.start