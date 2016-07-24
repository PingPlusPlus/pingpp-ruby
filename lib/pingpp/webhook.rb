module Pingpp
  module Webhook
    def self.verify?(request)
      if !Pingpp.pub_key
        return false
      end

      raw_data = nil
      if request.respond_to?('raw_post')
        raw_data = request.raw_post
      elsif request.respond_to?('body')
        raw_data = request.body
      else
        return false
      end

      headers = nil
      if request.respond_to?('headers')
        headers = request.headers
      elsif request.respond_to?('header')
        headers = request.header
      else
        return false
      end

      formated_headers = Util.format_headers(headers)
      return false if !formated_headers.has_key?(:x_pingplusplus_signature)

      signature = formated_headers[:x_pingplusplus_signature]
      rsa_public_key = OpenSSL::PKey.read(Pingpp.pub_key)
      return rsa_public_key.verify(OpenSSL::Digest::SHA256.new, Base64.decode64(signature), raw_data)
    end
  end
end
