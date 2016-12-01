module Pingpp
  module Util
    def self.objects_to_ids(h)
      case h
      when APIResource
        h.id
      when Hash
        res = {}
        h.each { |k, v| res[k] = objects_to_ids(v) unless v.nil? }
        res
      when Array
        h.map { |v| objects_to_ids(v) }
      else
        h
      end
    end

    def self.object_classes
      @object_classes ||= {
        'charge' => Charge,
        'list' => ListObject,
        'refund' => Refund,
        'red_envelope' => RedEnvelope,
        'transfer' => Transfer,
        'batch_refund' => BatchRefund,
        'batch_transfer' => BatchTransfer,
        'customs' => Customs
      }
    end

    def self.convert_to_pingpp_object(resp, opts)
      case resp
      when Array
        resp.map { |i| convert_to_pingpp_object(i, opts) }
      when Hash
        # Try converting to a known object class.  If none available, fall back to generic PingppObject
        object_classes.fetch(resp[:object], PingppObject).construct_from(resp, opts)
      else
        resp
      end
    end

    def self.file_readable(file)
      # This is nominally equivalent to File.readable?, but that can
      # report incorrect results on some more oddball filesystems
      # (such as AFS)
      begin
        File.open(file) { |f| }
      rescue
        false
      else
        true
      end
    end

    def self.symbolize_names(object)
      case object
      when Hash
        new_hash = {}
        object.each do |key, value|
          key = (key.to_sym rescue key) || key
          new_hash[key] = symbolize_names(value)
        end
        new_hash
      when Array
        object.map { |value| symbolize_names(value) }
      else
        object
      end
    end

    def self.url_encode(key)
      CGI.escape(key.to_s).gsub('%5B', '[').gsub('%5D', ']')
    end

    def self.flatten_params(params, parent_key=nil)
      result = []
      params.each do |key, value|
        calculated_key = parent_key ? "#{parent_key}[#{key}]" : "#{key}"
        if value.is_a?(Hash)
          result += flatten_params(value, calculated_key)
        elsif value.is_a?(Array)
          result += flatten_params_array(value, calculated_key)
        else
          result << [calculated_key, value]
        end
      end
      result
    end

    def self.flatten_params_array(value, calculated_key)
      result = []
      value.each do |elem|
        if elem.is_a?(Hash)
          result += flatten_params(elem, calculated_key)
        elsif elem.is_a?(Array)
          result += flatten_params_array(elem, calculated_key)
        else
          result << ["#{calculated_key}[]", elem]
        end
      end
      result
    end

    def self.format_headers(original_headers)
      new_headers = {}
      if !original_headers.respond_to?("each")
        return nil
      end

      original_headers.each do |k, h|
        if k.is_a?(Symbol)
          k = k.to_s
        end
        k = k[0, 5] == 'HTTP_' ? k[5..-1] : k
        new_k = k.gsub(/-/, '_').downcase.to_sym

        header = nil
        if h.is_a?(Array) && h.length > 0
          header = h[0]
        elsif h.is_a?(String)
          header = h
        end

        if header
          new_headers[new_k] = header
        end
      end

      return new_headers
    end

    def self.encode_parameters(params)
      Util.flatten_params(params).
        map { |k,v| "#{url_encode(k)}=#{url_encode(v)}" }.join('&')
    end

    def self.normalize_id(id)
      if id.kind_of?(Hash) # overloaded id
        params_hash = id.dup
        id = params_hash.delete(:id)
      else
        params_hash = {}
      end
      [id, params_hash]
    end

    def self.normalize_opts(opts)
      case opts
      when String
        {:api_key => opts}
      when Hash
        check_api_key!(opts.fetch(:api_key)) if opts.has_key?(:api_key)
        check_app!(opts.fetch(:app)) if opts.has_key?(:app)
        check_user!(opts.fetch(:user)) if opts.has_key?(:user)
        opts.clone
      else
        raise TypeError.new('normalize_opts expects a string or a hash')
      end
    end

    def self.check_api_key!(key)
      raise TypeError.new("api_key must be a string") unless key.is_a?(String)
      key
    end

    def self.check_app!(app)
      raise TypeError.new("app must be a string") unless app.is_a?(String)
      app
    end

    def self.check_user!(user)
      raise TypeError.new("user must be a string") unless user.is_a?(String)
      user
    end
  end
end
