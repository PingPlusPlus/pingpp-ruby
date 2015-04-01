require "pingpp"

Pingpp.api_key = "YOUR-KEY"
ch = Pingpp::Charge.retrieve("CHARGE-ID")
re = ch.refunds.create(:description => "Refund Description")