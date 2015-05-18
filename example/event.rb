require "pingpp"

Pingpp.api_key = "YOUR-KEY"

# retrieve event
Pingpp::Event.retrieve("EVENT-ID")

# list events
Pingpp::Event.all(:limit => 3)