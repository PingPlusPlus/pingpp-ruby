module Pingpp
  class UserBasedResource < APIResource

    def self.object_name
      class_name.downcase
    end

    def self.resource_url(opts={})
      if self == UserBasedResource
        raise NotImplementedError.new('UserBasedResource is an abstract class. You should perform actions on its subclasses (BalanceTransaction, etc.)')
      end

      app_id = opts[:app]
      unless app_id ||= Pingpp.app_id
        raise InvalidRequestError.new("Please set app_id using Pingpp.app_id = <APP_ID>", 'app_id')
      end

      unless user_id = opts[:user]
        raise InvalidRequestError.new("Please pass user_id in opts like {:user => <USER_ID>}", 'user')
      end

      url = "/v1/apps/#{app_id}/users/#{user_id}"

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
