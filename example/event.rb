require "pingpp"

Pingpp.api_key = "YOUR-KEY"

# retrieve an event
Pingpp::Event.retrieve("EVENT_ID")

# list all events
Pingpp::Event.all(:limit => 3)