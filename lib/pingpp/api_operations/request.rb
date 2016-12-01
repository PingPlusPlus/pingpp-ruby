module Pingpp
  module APIOperations
    module Request
      module ClassMethods
        OPTS_KEYS_TO_PERSIST = Set[:api_key, :api_base, :app, :user]

        def request(method, url, params={}, opts={})
          opts = Util.normalize_opts(opts)

          headers = opts.clone
          api_key = headers.delete(:api_key)
          api_base = headers.delete(:api_base)
          headers.delete(:app)
          headers.delete(:user)
          headers.delete(:parents)
          # Assume all remaining opts must be headers

          response, opts[:api_key] = Pingpp.request(
            method, url, api_key, params, headers, api_base
          )

          # Hash#select returns an array before 1.9
          opts_to_persist = {}
          opts.each do |k, v|
            if OPTS_KEYS_TO_PERSIST.include?(k)
              opts_to_persist[k] = v
            end
          end

          [response, opts_to_persist]
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end

      protected

      def request(method, url, params={}, opts={})
        opts = @opts.merge(Util.normalize_opts(opts))
        self.class.request(method, url, params, opts)
      end
    end
  end
end
