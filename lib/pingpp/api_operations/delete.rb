module Pingpp
  module APIOperations
    module Delete
      module ClassMethods
        def delete(id, params={}, opts={})
          response, opts = request(:delete, "#{resource_url(opts)}/#{id}", params, opts)
          Util.convert_to_pingpp_object(response, opts)
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end
