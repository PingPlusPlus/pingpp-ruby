module Pingpp
  class SingletonAPIResource < APIResource
    def self.resource_url(opts={})
      if self == SingletonAPIResource
        raise NotImplementedError.new('SingletonAPIResource is an abstract class.')
      end
      "/v1/#{CGI.escape(class_name.downcase)}"
    end

    def resource_url(opts={})
      self.class.resource_url(opts)
    end

    def self.retrieve(opts={})
      instance = self.new(nil, Util.normalize_opts(opts))
      instance.refresh
      instance
    end
  end
end
