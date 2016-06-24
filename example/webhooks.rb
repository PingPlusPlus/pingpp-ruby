=begin
  Ping++ Server SDK 说明：
  以下代码只是为了方便商户测试而提供的样例代码，商户可根据自己网站需求按照技术文档编写, 并非一定要使用该代码。
  接入 webhooks 流程参考开发者中心：https://www.pingxx.com/docs/webhooks/webhooks
  该代码仅供学习和研究 Ping++ SDK 使用，仅供参考。
=end
require 'webrick'
require 'json'
require 'OpenSSL'
require 'base64'

# 验证 webhooks 签名
def verify_signature(raw_data, signature, pub_key_path)
  rsa_public_key = OpenSSL::PKey.read(File.read(pub_key_path))
  return rsa_public_key.verify(OpenSSL::Digest::SHA256.new, Base64.decode64(signature), raw_data)
end

class Webhooks < WEBrick::HTTPServlet::AbstractServlet
  def do_POST(request, response)
    # header 的 key 做格式化处理，并且转成 Symbol
    headers = get_headers(request.header)

    # 签名在头部信息的 x-pingplusplus-signature 字段
    if !headers.has_key?(:x_pingplusplus_signature)
      response.status = 401
      return
    end
    # 原始请求数据是待验签数据，请根据实际情况获取
    raw_data = request.body
    signature = headers[:x_pingplusplus_signature]
    # Ping++ 公钥，获取路径：登录 [Dashboard](https://dashboard.pingxx.com)->点击管理平台右上角公司名称->开发信息-> Ping++ 公钥
    pub_key_path = File.dirname(__FILE__) + '/pingpp_rsa_public_key.pem'

    if verify_signature(raw_data, signature, pub_key_path)
      status = 400
      response_body = ''
      begin
        event = JSON.parse(request.body)
        # 根据你的逻辑处理 event
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
      response.body = response_body
      response['Content-Type'] = 'text/plain; charset=utf-8'
      response.status = status # 2XX 表示成功接收
    else
      response.status = 403
    end
  end
end

# 格式化 key
def get_headers(original_headers)
  new_headers = {}
  if !original_headers.respond_to?("each")
    return nil
  end

  original_headers.each do |k, h|
    if k.is_a?(Symbol)
      k = k.to_s
    end
    k = k[0, 5] == 'HTTP_' ? k[5..-1] : k
    new_k = k.gsub(/-/, '_').downcase.to_sym

    header = nil
    if h.is_a?(Array) && h.length > 0
      header = h[0]
    elsif h.is_a?(String)
      header = h
    end

    if header
      new_headers[new_k] = header
    end
  end

  return new_headers
end

server = WEBrick::HTTPServer.new(:Port => 8000)
server.mount "/webhooks", Webhooks
trap "INT" do server.shutdown end
server.start
