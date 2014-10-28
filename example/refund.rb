require "pingpp"

Pingpp.api_key = "YOUR-KEY"
ch = Pingpp::Charge.retrieve("ch_0ijQi5LKqT5sEiOePOKWb1mF")
refund = ch.refunds.create(:description => "refund description")