require 'webrick'
require 'json'
require "digest/md5"
require 'pingpp'

# 创建 charge
class Pay < WEBrick::HTTPServlet::AbstractServlet
  def do_POST(request, response)
    Pingpp.api_key = "YOUR-KEY"
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

# 异步通知
class Notify < WEBrick::HTTPServlet::AbstractServlet
  def do_POST(request, response)
    response_body = 'fail'
    begin
      post_data = JSON.parse(request.body)
      if post_data['object'].nil?
      elsif post_data['object'] == 'charge'
        response_body = 'success'
        # 开发者在此处加入对支付异步通知的处理代码
      elsif post_data['object'] == 'refund'
        response_body = 'success'
        # 开发者在此处加入对退款异步通知的处理代码
      end
    rescue JSON::ParserError
      response_body = 'fail'
    end
    response.status = 200
    response['Content-Type'] = "text/plain"
    response.body = response_body
  end
end

server = WEBrick::HTTPServer.new(:Port => 8000)
server.mount "/pay", Pay
server.mount "/notify", Notify
trap "INT" do server.shutdown end
server.start