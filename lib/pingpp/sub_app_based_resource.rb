module Pingpp
  class SubAppBasedResource < APIResource

    def self.object_name
      class_name.downcase
    end

    def self.resource_url(opts={})
      if self == SubAppBasedResource
        raise NotImplementedError.new('SubAppBasedResource is an abstract class. You should perform actions on its subclasses (Channel, etc.)')
      end

      app_id = opts[:app]
      unless app_id ||= Pingpp.app_id
        raise InvalidRequestError.new("Please set app_id using Pingpp.app_id = <APP_ID>", 'app_id')
      end

      unless sub_app_id = opts[:sub_app]
        raise InvalidRequestError.new("Please pass sub_app_id in opts like {:sub_app => <SUB_APP_ID>}", 'sub_app')
      end

      url = "/v1/apps/#{app_id}/sub_apps/#{sub_app_id}"

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
