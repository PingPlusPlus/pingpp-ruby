=begin
  Ping++ Server SDK 说明：
  以下代码只是为了方便商户测试而提供的样例代码，商户可根据自己网站需求按照技术文档编写, 并非一定要使用该代码。
  接入支付流程参考开发者中心：https://www.pingxx.com/docs/server/charge ，文档可筛选后端语言和接入渠道。
  该代码仅供学习和研究 Ping++ SDK 使用，仅供参考。
=end
require 'webrick'
require 'json'
require 'digest/md5'
require 'pingpp'

# api_key 获取方式：登录 [Dashboard](https://dashboard.pingxx.com)->点击管理平台右上角公司名称->开发信息-> Secret Key
API_KEY = 'sk_test_ibbTe5jLGCi5rzfH4OqPW9KC'
# app_id 获取方式：登录 [Dashboard](https://dashboard.pingxx.com)->点击你创建的应用->应用首页->应用 ID(App ID)
APP_ID = 'app_1Gqj58ynP0mHeX1q'

# 创建 charge
class Pay < WEBrick::HTTPServlet::AbstractServlet
  def do_POST(request, response)
    Pingpp.api_key = API_KEY
    Pingpp.parse_headers(request.header)

=begin
  设置请求签名密钥，密钥对需要你自己用 openssl 工具生成，如何生成可以参考帮助中心：https://help.pingxx.com/article/123161；
  生成密钥后，需要在代码中设置请求签名的私钥(rsa_private_key.pem)；
  然后登录 [Dashboard](https://dashboard.pingxx.com)->点击右上角公司名称->开发信息->商户公钥（用于商户身份验证）
  将你的公钥复制粘贴进去并且保存->先启用 Test 模式进行测试->测试通过后启用 Live 模式
=end
    # 设置你的私钥路径，用于请求的签名
    Pingpp.private_key_path = File.dirname(__FILE__) + '/your_rsa_private_key.pem'

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

    # 以下 channel 仅为部分需要 extra 参数的示例，详见 https://www.pingxx.com/document/api#api-c-new
    case channel
    when 'alipay_wap'
      extra = {
        # success_url 和 cancel_url 在本地测试不要写 localhost ，请写 127.0.0.1。URL 后面不要加自定义参数
        'success_url' => 'http://www.yourdomain.com/success',
        'cancel_url'  => 'http://www.yourdomain.com/cancel'
      }
    when 'upacp_wap'
      extra = {
        'result_url' => 'http://www.yourdomain.com/result?code='# 银联同步回调地址
      }
    when 'bfb_wap'
      extra = {
        'bfb_login' => true,# 百度钱包同步回调地址
        'result_url' => 'http://www.yourdomain.com/success'# 是否需要登录百度钱包来进行支付
      }
    when 'wx_pub'
      extra = {
        'open_id' => open_id # 用户在商户微信公众号下的唯一标识，获取方式可参考 pingpp-ruby\example\wx_pub_get_openid.rb
      }
    end
    # 商户系统自己生成的订单号。如果是【壹收款】，则使用客户端传上来的 'order_no'。
    order_no = Digest::MD5.hexdigest(Time.now.to_i.to_s)[0,12]# 推荐使用 8-20 位，要求数字或字母，不允许其他字符
    response_body = ''
    begin
      ch = Pingpp::Charge.create(
        :order_no  => order_no,# 订单号推荐使用 8-20 位，要求数字或字母，不允许其他字符
        :app       => {:id => APP_ID},
        :channel   => channel,# 支付使用的第三方支付渠道取值，请参考：https://www.pingxx.com/api#api-c-new
        :amount    => amount,# 订单总金额, 人民币单位：分（如订单总金额为 1 元，此处请填 100）
        :client_ip => client_ip,# 发起支付请求客户端的 IP 地址，格式为 IPV4，如: 127.0.0.1
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
server.mount '/charge', Pay
trap 'INT' do server.shutdown end
server.start
