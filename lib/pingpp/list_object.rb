module Pingpp
  class ListObject < PingppObject

    def [](k)
      case k
      when String, Symbol
        super
      else
        raise ArgumentError.new("You tried to access the #{k.inspect} index, but ListObject types only support String keys. (HINT: List calls return an object with a 'data' (which is the data array). You likely want to call #data[#{k.inspect}])")
      end
    end

    def each(&blk)
      self.data.each(&blk)
    end

    def retrieve(id, api_key=nil)
      api_key ||= @api_key
      response, api_key = Pingpp.request(:get,"#{url}/#{CGI.escape(id)}", api_key)
      Util.convert_to_pingpp_object(response, api_key)
    end

    def create(params={}, api_key=nil)
      api_key ||= @api_key
      response, api_key = Pingpp.request(:post, url, api_key, params)
      Util.convert_to_pingpp_object(response, api_key)
    end

    def all(params={}, api_key=nil)
      api_key ||= @api_key
      response, api_key = Pingpp.request(:get, url, api_key, params)
      Util.convert_to_pingpp_object(response, api_key)
    end
  end
end
