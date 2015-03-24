require "pingpp"
require "digest/md5"
require "date"

Pingpp.api_key = "YOUR-KEY"

formated_date = DateTime.now.strftime("%Y%m%d")
mch_id = 'MERCHANT-ID';
order_no = mch_id + formated_date + "123";
begin
  ch = Pingpp::RedEnvelope.create(
    :order_no => order_no,
    :app      => {"id" => "YOUR-APP-ID"},
    :channel  => "wx_pub",
    :amount   => 100,
    :currency => "cny",
    :recipient=> "Recipient openid",
    :subject  => "Your Subject",
    :body     => "Your Body",
    :description => "Description",
    :extra    => {
      "nick_name" => "Nick Name",
      "send_name" => "Send Name"
    }
  )

  puts ch
rescue Pingpp::PingppError => e
  puts e
end
