require "pingpp"
require "digest/md5"

Pingpp.api_key = "YOUR-KEY"

channel = "alipay"
extra = {}
case channel
when "alipay_wap"
  extra = {
    :success_url => "http://www.yourdomain.com/success",
    :cancel_url  => "http://www.yourdomain.com/cancel"
  }
when "upacp_wap"
  extra = {
    :result_url => "http://www.yourdomain.com/result?code="
  }
end
orderNo = Digest::MD5.hexdigest(Time.now.to_i.to_s)[0,12]
# Pingpp.parse_headers(headers) # request headers
Pingpp::Charge.create(
  :order_no  => orderNo,
  :app       => { :id => "YOUR-APP-ID" },
  :channel   => channel,
  :amount    => 100,
  :client_ip => "127.0.0.1",
  :currency  => "cny",
  :subject   => "Your Subject",
  :body      => "Your Body",
  :extra     => extra
)