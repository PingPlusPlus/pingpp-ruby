# Pingpp Ruby bindings
# API spec at https://pingxx.com/document/api
require 'cgi'
require 'set'
require 'openssl'
require 'rest-client'
require 'json'
require 'base64'

# Version
require 'pingpp/version'

# API operations
require 'pingpp/api_operations/create'
require 'pingpp/api_operations/update'
require 'pingpp/api_operations/delete'
require 'pingpp/api_operations/list'

# Resources
require 'pingpp/util'
require 'pingpp/pingpp_object'
require 'pingpp/api_resource'
require 'pingpp/singleton_api_resource'
require 'pingpp/list_object'
require 'pingpp/charge'
require 'pingpp/refund'
require 'pingpp/red_envelope'
require 'pingpp/event'
require 'pingpp/transfer'

# Errors
require 'pingpp/errors/pingpp_error'
require 'pingpp/errors/api_error'
require 'pingpp/errors/api_connection_error'
require 'pingpp/errors/invalid_request_error'
require 'pingpp/errors/authentication_error'
require 'pingpp/errors/channel_error'

# WxPubOauth
require 'pingpp/wx_pub_oauth'

module Pingpp
  DEFAULT_CA_BUNDLE_PATH = File.dirname(__FILE__) + '/data/ca-certificates.crt'
  @api_base = 'https://api.pingxx.com'

  @api_version = '2015-10-10'

  @ssl_bundle_path  = DEFAULT_CA_BUNDLE_PATH
  @verify_ssl_certs = true

  HEADERS_TO_PARSE = [:pingpp_one_version, :pingpp_sdk_version]

  class << self
    attr_accessor :api_key, :api_base, :verify_ssl_certs, :api_version, :parsed_headers, :private_key
  end

  def self.api_url(url='')
    @api_base + url
  end

  def self.parse_headers(headers)
    @parsed_headers = {}
    if headers && headers.respond_to?("each")
      headers.each do |k, v|
        k = k[0, 5] == 'HTTP_' ? k[5..-1] : k
        header_key = k.gsub(/-/, '_').to_s.downcase.to_sym
        if HEADERS_TO_PARSE.include?(header_key)
          if v.is_a?(String)
            @parsed_headers[header_key] = v
          elsif v.is_a?(Array)
            @parsed_headers[header_key] = v[0]
          end
        end
      end
    end
  end

  def self.request(method, url, api_key, params={}, headers={})
    unless api_key ||= @api_key
      raise AuthenticationError.new('No API key provided. ' +
        'Set your API key using "Pingpp.api_key = <API-KEY>". ' +
        'You can generate API keys from the Pingpp web interface. ' +
        'See https://pingxx.com/document/api for details.')
    end

    if api_key =~ /\s/
      raise AuthenticationError.new('Your API key is invalid, as it contains ' +
        'whitespace. (HINT: You can double-check your API key from the ' +
        'Pingpp web interface. See https://pingxx.com/document/api for details.)')
    end

    if verify_ssl_certs
      request_opts = {:verify_ssl => OpenSSL::SSL::VERIFY_PEER,
                      :ssl_ca_file => @ssl_bundle_path,
                      :ssl_version => 'TLSv1'}
    else
      request_opts = {:verify_ssl => false,
                      :ssl_version => 'TLSv1'}
      unless @verify_ssl_warned
        @verify_ssl_warned = true
        $stderr.puts("WARNING: Running without SSL cert verification. " \
          "You should never do this in production. " \
          "Execute 'Pingpp.verify_ssl_certs = true' to enable verification.")
      end
    end

    params = Util.objects_to_ids(params)
    url = api_url(url)

    case method.to_s.downcase.to_sym
    when :get, :head, :delete
      # Make params into GET parameters
      url += "#{URI.parse(url).query ? '&' : '?'}#{uri_encode(params)}" if params && params.any?
      payload = nil
    else
      payload = JSON.generate(params)
    end

    request_opts.update(:headers => request_headers(api_key, method.to_s.downcase.to_sym == :post, payload).update(headers),
                        :method => method, :open_timeout => 30,
                        :payload => payload, :url => url, :timeout => 80)

    begin
      response = execute_request(request_opts)
    rescue SocketError => e
      handle_restclient_error(e)
    rescue NoMethodError => e
      # Work around RestClient bug
      if e.message =~ /\WRequestFailed\W/
        e = APIConnectionError.new('Unexpected HTTP response code')
        handle_restclient_error(e)
      else
        raise
      end
    rescue RestClient::ExceptionWithResponse => e
      if rcode = e.http_code and rbody = e.http_body
        handle_api_error(rcode, rbody)
      else
        handle_restclient_error(e)
      end
    rescue RestClient::Exception, Errno::ECONNREFUSED => e
      handle_restclient_error(e)
    end

    [parse(response), api_key]
  end

  private

  def self.user_agent
    @uname ||= get_uname
    lang_version = "#{RUBY_VERSION} p#{RUBY_PATCHLEVEL} (#{RUBY_RELEASE_DATE})"

    {
      :bindings_version => Pingpp::VERSION,
      :lang => 'ruby',
      :lang_version => lang_version,
      :platform => RUBY_PLATFORM,
      :publisher => 'pingpp',
      :uname => @uname
    }

  end

  def self.get_uname
    `uname -a 2>/dev/null`.strip if RUBY_PLATFORM =~ /linux|darwin/i
  rescue Errno::ENOMEM => ex # couldn't create subprocess
    "uname lookup failed"
  end

  def self.uri_encode(params)
    Util.flatten_params(params).
      map { |k,v| "#{k}=#{Util.url_encode(v)}" }.join('&')
  end

  def self.request_headers(api_key, is_post=false, data=nil)
    headers = {
      :user_agent => "Pingpp/v1 RubyBindings/#{Pingpp::VERSION}",
      :authorization => "Bearer #{api_key}",
      :content_type => is_post ? 'application/json' : 'application/x-www-form-urlencoded'
    }

    headers[:pingplusplus_version] = api_version if api_version
    headers.update(parsed_headers) if parsed_headers && !parsed_headers.empty?

    begin
      headers.update(:x_pingpp_client_user_agent => JSON.generate(user_agent))
    rescue => e
      headers.update(:x_pingpp_client_raw_user_agent => user_agent.inspect,
                     :error => "#{e} (#{e.class})")
    end

    if is_post && private_key && data
      signature = sign_request(data, private_key)
      headers.update(:pingplusplus_signature => signature)
    end

    headers
  end

  def self.execute_request(opts)
    RestClient::Request.execute(opts)
  end

  def self.parse(response)
    begin
      # Would use :symbolize_names => true, but apparently there is
      # some library out there that makes symbolize_names not work.
      response = JSON.parse(response.body)
    rescue JSON::ParserError
      raise general_api_error(response.code, response.body)
    end

    Util.symbolize_names(response)
  end

  def self.private_key_path=(private_key_path)
    @private_key = File.read(private_key_path)
  end

  def self.sign_request(data, pri_key)
    pkey = OpenSSL::PKey.read(pri_key)
    return Base64.strict_encode64(pkey.sign(OpenSSL::Digest::SHA256.new, data))
  end

  def self.general_api_error(rcode, rbody)
    APIError.new("Invalid response object from API: #{rbody.inspect} " +
                 "(HTTP response code was #{rcode})", rcode, rbody)
  end

  def self.handle_api_error(rcode, rbody)
    begin
      error_obj = JSON.parse(rbody)
      error_obj = Util.symbolize_names(error_obj)
      error = error_obj[:error] or raise PingppError.new # escape from parsing

    rescue JSON::ParserError, PingppError
      raise general_api_error(rcode, rbody)
    end

    case rcode
    when 400, 404
      raise invalid_request_error error, rcode, rbody, error_obj
    when 401
      raise authentication_error error, rcode, rbody, error_obj
    when 402
      raise channel_error error, rcode, rbody, error_obj
    else
      raise api_error error, rcode, rbody, error_obj
    end

  end

  def self.invalid_request_error(error, rcode, rbody, error_obj)
    InvalidRequestError.new(error[:message], error[:param], rcode,
                            rbody, error_obj)
  end

  def self.authentication_error(error, rcode, rbody, error_obj)
    AuthenticationError.new(error[:message], rcode, rbody, error_obj)
  end

  def self.channel_error(error, rcode, rbody, error_obj)
    ChannelError.new(error[:message], error[:code], error[:param], rcode, rbody, error_obj)
  end

  def self.api_error(error, rcode, rbody, error_obj)
    APIError.new(error[:message], rcode, rbody, error_obj)
  end

  def self.handle_restclient_error(e)
    connection_message = "Please check your internet connection and try again. " \
        "If this problem persists, you should check Pingpp's service status at " \
        "https://www.pingxx.com/status"

    case e
    when RestClient::RequestTimeout
      message = "Could not connect to Pingpp (#{@api_base}). #{connection_message}"

    when RestClient::ServerBrokeConnection
      message = "The connection to the server (#{@api_base}) broke before the " \
        "request completed. #{connection_message}"

    when RestClient::SSLCertificateNotVerified
      message = "Could not verify Pingpp's SSL certificate. " \
        "Please make sure that your network is not intercepting certificates. " \
        "(Try going to (#{@api_base}) in your browser.)"

    when SocketError
      message = "Unexpected error communicating when trying to connect to Pingpp. " \
        "You may be seeing this message because your DNS is not working. " \
        "To check, try running 'host pingxx.com' from the command line."

    else
      message = "Unexpected error communicating with Pingpp."

    end

    raise APIConnectionError.new(message + "\n\n(Network error: #{e.message})")
  end
end
