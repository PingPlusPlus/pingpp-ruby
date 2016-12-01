module Pingpp
  class ListObject < PingppObject
    include Pingpp::APIOperations::List
    include Pingpp::APIOperations::Request
    include Pingpp::APIOperations::Create

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

    def empty?
      self.data.empty?
    end

    def retrieve(id, opts={})
      id, retrieve_params = Util.normalize_id(id)
      response, opts = request(:get, "#{resource_url(opts)}/#{CGI.escape(id)}", retrieve_params, opts)
      Util.convert_to_pingpp_object(response, opts)
    end

    def resource_url(opts={})
      self.url ||
        raise(ArgumentError, "List object does not contain a 'url' field.")
    end
  end
end
