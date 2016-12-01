module Pingpp
  module APIOperations
    module Update
      module ClassMethods
        def update(id, params={}, opts={})
          response, opts = request(:put, "#{resource_url(opts)}/#{id}", params, opts)
          Util.convert_to_pingpp_object(response, opts)
        end
      end

      def save(params={}, opts={})
        update_attributes(params)

        params = params.reject { |k, _| respond_to?(k) }

        values = self.serialize_params(self).merge(params)

        values.delete(:id)

        response, opts = request(:put, save_url, values, opts)
        initialize_from(response, opts)

        self
      end

      def self.included(base)
        base.extend(ClassMethods)
      end

      private

      def save_url
        if self[:id] == nil && self.class.respond_to?(:create)
          self.class.resource_url
        else
          resource_url
        end
      end
    end
  end
end
