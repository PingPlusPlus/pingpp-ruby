module Pingpp
  module APIOperations
    module Create
      def create(params={}, opts={})
        response, opts = request(:post, resource_url(opts), params, opts)
        Util.convert_to_pingpp_object(response, opts)
      end
    end
  end
end
