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
    # 签名在头部信息的 x-pingplusplus-signature 字段
    if !request.header.has_key?('x-pingplusplus-signature')
      response.status = 401
      return
    end
    # 原始请求数据是待验签数据，请根据实际情况获取
    raw_data = request.body
    signature = request.header['x-pingplusplus-signature'][0]
    # 请从 https://dashboard.pingxx.com 获取「Webhooks 验证 Ping++ 公钥」
    pub_key_path = File.dirname(__FILE__) + '/rsa_public_key.pem'
    if verify_signature(raw_data, signature, pub_key_path)
      event = JSON.parse(raw_data)
      # 根据你的逻辑处理 event
      response.status = 200 # 2XX 表示成功接收
    else
      response.status = 403
    end
  end
end

server = WEBrick::HTTPServer.new(:Port => 8000)
server.mount "/webhooks", Webhooks
trap "INT" do server.shutdown end
server.start