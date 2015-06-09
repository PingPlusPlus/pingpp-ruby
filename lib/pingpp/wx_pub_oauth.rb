require 'digest/sha1'

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
      response = get_request(url)
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

    def self.get_jsapi_ticket(app_id, app_secret)
      query_parts = {
        'appid' => app_id,
        'secret' => app_secret,
        'grant_type' => 'client_credential'
      }
      query_str = Pingpp.uri_encode(query_parts)
      access_token_url = 'https://api.weixin.qq.com/cgi-bin/token?' + query_str
      resp = get_request(access_token_url)
      if !resp['errcode'].nil? then
        return resp
      end
      query_parts = {
        'access_token' => resp['access_token'],
        'type' => 'jsapi'
      }
      query_str = Pingpp.uri_encode(query_parts)
      jsapi_ticket_url = 'https://api.weixin.qq.com/cgi-bin/ticket/getticket?' + query_str
      jsapi_ticket = get_request(jsapi_ticket_url)
    end

    def self.get_signature(charge, jsapi_ticket, url)
      if charge['credential'].nil? || charge['credential']['wx_pub'].nil? then
        return nil
      end
      credential = charge['credential']['wx_pub']
      array_to_sign = [
        'jsapi_ticket=' + jsapi_ticket,
        'noncestr=' + credential['nonceStr'],
        'timestamp=' + credential['timeStamp'].to_s,
        'url=' + url.split('#')[0]
      ]
      siganture = Digest::SHA1.hexdigest(array_to_sign.join('&'))
    end
  end
end
