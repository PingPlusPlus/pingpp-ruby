require "pingpp"
require "digest/md5"

Pingpp.api_key = "YOUR-KEY"

begin
  red = Pingpp::RedEnvelope.create(
    :order_no    => "123456789",
    :app         => { :id => "YOUR-APP-ID" },
    :channel     => "wx_pub",
    :amount      => 100,
    :currency    => "cny",
    :subject     => "Your Subject",
    :body        => "Your Body",
    :extra       => {
      :nick_name => "Nick Name",
      :send_name => "Send Name"
    },
    :recipient   => "Openid",
    :description => "Your Description"
  )

  puts red
rescue Pingpp::PingppError => e
  puts e
end
