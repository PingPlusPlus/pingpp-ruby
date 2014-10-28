require "pingpp"

Pingpp.api_key = "YOUR-KEY"
Pingpp::Charge.all(:limit => 5)