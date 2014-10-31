require "pingpp"
require "digest/md5"

Pingpp.api_key = "YOUR-KEY"
orderNo = Digest::MD5.hexdigest(Time.now.to_i.to_s)[0,12]
Pingpp::Charge.create(
  :subject  => "Charge Subject",
  :body     => "Charge Body",
  :amount   => 100,
  :order_no => orderNo,
  :channel  => Pingpp::Channel::ALIPAY,
  :currency => 'cny',
  :client_ip=> '127.0.0.1',
  :app => {'id' => "YOUR-APP-ID"}
)