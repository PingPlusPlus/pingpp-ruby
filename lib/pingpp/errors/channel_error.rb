module Pingpp
  class ChannelError < PingppError
    attr_accessor :param
    attr_accessor :code

    def initialize(message, code, param=nil, http_status=nil, http_body=nil,
                   json_body=nil, http_headers=nil)
      super(message, http_status, http_body, json_body, http_headers)
      @code = code
      @param = param
    end
  end
end
