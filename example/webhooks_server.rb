require 'webrick'
require 'json'

class Webhooks < WEBrick::HTTPServlet::AbstractServlet
  def do_POST(request, response)
    status = 400
    response_body = '' # 可自定义
    begin
      event = JSON.parse(request.body)
      if event['type'].nil?
        response_body = 'Event 对象中缺少 type 字段'
      elsif event['type'] == 'charge.succeeded'
        # 开发者在此处加入对支付异步通知的处理代码
        status = 200
        response_body = 'OK'
      elsif event['type'] == 'refund.succeeded'
        # 开发者在此处加入对退款异步通知的处理代码
        status = 200
        response_body = 'OK'
      else
        response_body = '未知 Event 类型'
      end
    rescue JSON::ParserError
      response_body = 'JSON 解析失败'
    end
    response.status = status
    response['Content-Type'] = 'text/plain; charset=utf-8'
    response.body = response_body
  end
end

server = WEBrick::HTTPServer.new(:Port => 8000)
server.mount '/webhooks', Webhooks
trap 'INT' do server.shutdown end
server.start