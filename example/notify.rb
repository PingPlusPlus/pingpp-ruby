require 'webrick'
require 'json'

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
server.mount "/notify", Notify
trap "INT" do server.shutdown end
server.start
