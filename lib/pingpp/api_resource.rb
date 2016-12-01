module Pingpp
  class APIResource < PingppObject
    include Pingpp::APIOperations::Request

    def self.class_name
      self.name.split('::')[-1]
    end

    def self.object_name
      class_name.downcase
    end

    def self.uri_object_name
      object_name
    end

    def self.resource_url(opts={})
      if self == APIResource
        raise NotImplementedError.new('APIResource is an abstract class.  You should perform actions on its subclasses (Charge, etc.)')
      end

      if opts.has_key?(:parents)
        if opts[:parents].is_a?(Array)
          "/v1/#{opts[:parents].join('/')}/#{CGI.escape(uri_object_name.downcase)}s"
        else
          raise ArgumentError.new("opts[:parents] should be an Array")
        end
      else
        "/v1/#{CGI.escape(uri_object_name.downcase)}s"
      end
    end

    def resource_url(opts={})
      unless id = self['id']
        raise InvalidRequestError.new("Could not determine which URL to request: #{self.class} instance has invalid ID: #{id.inspect}", 'id')
      end
      "#{self.class.resource_url(opts)}/#{CGI.escape(id)}"
    end

    def refresh
      response, opts = request(:get, resource_url(@opts), @retrieve_params)
      initialize_from(response, opts)
    end

    def self.retrieve(id, opts={})
      opts = Util.normalize_opts(opts)
      instance = self.new(id, opts)
      instance.refresh
      instance
    end
  end
end
