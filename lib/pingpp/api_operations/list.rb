module Pingpp
  module APIOperations
    module List
      def list(filters={}, opts={})
        opts = Util.normalize_opts(opts)

        response, opts = request(:get, resource_url(opts), filters, opts)
        ListObject.construct_from(response, opts)
      end

      alias :all :list
    end
  end
end
