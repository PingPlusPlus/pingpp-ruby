module Pingpp
  class SingletonAppBasedResource < APIResource
    def self.resource_url(opts={})
      if self == SingletonAPIResource
        raise NotImplementedError.new('SingletonAPIResource is an abstract class.')
      end

      app_id = opts[:app]
      unless app_id ||= Pingpp.app_id
        raise InvalidRequestError.new("Please set app_id using Pingpp.app_id = <APP_ID>", 'app_id')
      end

      "/v1/apps/#{app_id}/#{CGI.escape(uri_object_name.downcase)}"
    end

    def resource_url(opts={})
      self.class.resource_url(opts)
    end

    def self.retrieve(params={}, opts={})
      instance = self.new(params, Util.normalize_opts(opts))
      instance.refresh
      instance
    end
  end
end
