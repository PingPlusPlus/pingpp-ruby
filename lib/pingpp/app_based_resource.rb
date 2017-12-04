module Pingpp
  class AppBasedResource < APIResource

    def self.resource_url(opts={})
      if self == AppBasedResource
        raise NotImplementedError.new('AppBasedResource is an abstract class. You should perform actions on its subclasses (User, etc.)')
      end

      app_id = opts[:app]
      unless app_id ||= Pingpp.app_id
        raise InvalidRequestError.new("Please set app_id using Pingpp.app_id = <APP_ID>", 'app_id')
      end

      url = "/v1/apps/#{app_id}"

      if opts.has_key?(:parents)
        if opts[:parents].is_a?(Array)
          url + "/#{opts[:parents].join('/')}/#{CGI.escape(uri_object_name.downcase)}s"
        else
          raise ArgumentError.new("opts[:parents] should be an Array")
        end
      else
        url + "/#{CGI.escape(uri_object_name.downcase)}s"
      end
    end
  end
end
