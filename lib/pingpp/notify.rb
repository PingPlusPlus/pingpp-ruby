module Pingpp
  module Notify
    def self.verify?(request)
      raw_data = request.raw_post
      headers = Pingpp.parse_headers(request.headers)
      # 签名在头部信息的 x-pingplusplus-signature 字段
      return false if !headers.has_key?('HTTP_X_PINGPLUSPLUS_SIGNATURE')
      signature = headers['HTTP_X_PINGPLUSPLUS_SIGNATURE']
      rsa_public_key = OpenSSL::PKey.read(Pingpp.pub_key)
      return rsa_public_key.verify(OpenSSL::Digest::SHA256.new, Base64.decode64(signature), raw_data)
    end
  end
end
