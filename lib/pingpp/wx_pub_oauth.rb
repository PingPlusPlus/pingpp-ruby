module Pingpp
  module WxPubOauth
    def self.create_oauth_url_for_code(app_id, redirect_url, more_info = false)
      query_parts = {
        'appid' => app_id,
        'redirect_uri' => redirect_url,
        'response_type' => 'code',
        'scope' => more_info ? 'snsapi_userinfo' : 'snsapi_base'
      }
      query_str = Pingpp.uri_encode(query_parts)
      'https://open.weixin.qq.com/connect/oauth2/authorize?' + query_str + '#wechat_redirect'
    end

    def self.get_openid(app_id, app_secret, code)
      url = create_oauth_url_for_openid(app_id, app_secret, code)
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
      if response['openid'].nil? then
        return nil, response
      else
        return response['openid'], nil
      end
    end

    def self.create_oauth_url_for_openid(app_id, app_secret, code)
      query_parts = {
        'appid' => app_id,
        'secret' => app_secret,
        'code' => code,
        'grant_type' => 'authorization_code'
      }
      query_str = Pingpp.uri_encode(query_parts)
      'https://api.weixin.qq.com/sns/oauth2/access_token?' + query_str
    end
  end
end
