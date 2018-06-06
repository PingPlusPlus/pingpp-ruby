module Pingpp
  module WxLiteOauth
    def self.get_openid(app_id, app_secret, code)
      response = get_session(app_id, app_secret, code)
      if response['openid'].nil? then
        return nil, response
      else
        return response['openid'], nil
      end
    end

    def self.get_session(app_id, app_secret, code)
      url = create_oauth_url_for_openid(app_id, app_secret, code)
      return get_request(url)
    end

    def self.create_oauth_url_for_openid(app_id, app_secret, code)
      query_parts = {
        'appid' => app_id,
        'secret' => app_secret,
        'js_code' => code,
        'grant_type' => 'authorization_code'
      }
      query_str = Util.encode_parameters(query_parts)
      'https://api.weixin.qq.com/sns/jscode2session?' + query_str
    end

    def self.get_request(url)
      request_opts = {
        :url => url,
        :verify_ssl => false,
        :ssl_version => 'TLSv1',
        :method => 'GET',
        :headers => false,
        :open_timeout => 30,
        :timeout => 30
      }
      response = RestClient::Request.execute(request_opts)
      response = JSON.parse(response.body)
    end
  end
end
