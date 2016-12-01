# Pingpp Ruby bindings
# API spec at https://www.pingxx.com/api
require 'cgi'
require 'set'
require 'openssl'
require 'rest-client'
require 'json'
require 'base64'
require 'socket'
require 'rbconfig'

# Version
require 'pingpp/version'

# API operations
require 'pingpp/api_operations/create'
require 'pingpp/api_operations/update'
require 'pingpp/api_operations/delete'
require 'pingpp/api_operations/list'
require 'pingpp/api_operations/request'

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
require 'pingpp/webhook'
require 'pingpp/identification'
require 'pingpp/customs'
require 'pingpp/batch_refund'
require 'pingpp/batch_transfer'

# Errors
require 'pingpp/errors/pingpp_error'
require 'pingpp/errors/api_error'
require 'pingpp/errors/api_connection_error'
require 'pingpp/errors/invalid_request_error'
require 'pingpp/errors/authentication_error'
require 'pingpp/errors/channel_error'
require 'pingpp/errors/rate_limit_error'

# WxPubOauth
require 'pingpp/wx_pub_oauth'

module Pingpp
  DEFAULT_CA_BUNDLE_PATH = File.dirname(__FILE__) + '/data/ca-certificates.crt'

  RETRY_EXCEPTIONS = [
    Errno::ECONNREFUSED,
    Errno::ECONNRESET,
    Errno::ETIMEDOUT,
    RestClient::Conflict,
    RestClient::RequestTimeout,
  ].freeze

  @api_base = 'https://api.pingxx.com'

  @ca_bundle_path  = DEFAULT_CA_BUNDLE_PATH
  @verify_ssl_certs = true

  @open_timeout = 30
  @timeout = 80

  @max_network_retries = 0
  @max_network_retry_delay = 2
  @initial_network_retry_delay = 0.5

  HEADERS_TO_PARSE = [:pingpp_one_version, :pingpp_sdk_version]

  class << self
    attr_accessor :api_key, :api_base, :verify_ssl_certs, :api_version,
                  :parsed_headers, :private_key, :pub_key, :app_id, :timeout,
                  :open_timeout
    attr_reader :max_network_retry_delay, :initial_network_retry_delay
  end

  def self.api_url(url='', api_base_url=nil)
    (api_base_url || @api_base) + url
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

  def self.request(method, url, api_key, params={}, headers={}, api_base_url=nil)
    api_base_url = api_base_url || @api_base

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
                      :ssl_ca_file => @ca_bundle_path,
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
    url = api_url(url, api_base_url)

    method_sym = method.to_s.downcase.to_sym
    case method_sym
    when :get, :head, :delete
      # Make params into GET parameters
      url += "#{URI.parse(url).query ? '&' : '?'}#{Util.encode_parameters(params)}" if params && params.any?
      payload = nil
    else
      payload = JSON.generate(params)
    end

    request_opts.update(:headers => request_headers(api_key, method_sym, payload, url).update(headers),
                        :method => method, :open_timeout => open_timeout,
                        :payload => payload, :url => url, :timeout => timeout)

    response = execute_request_with_rescues(request_opts, api_base_url)

    [parse(response), api_key]
  end

  def self.max_network_retries
    @max_network_retries
  end

  def self.max_network_retries=(val)
    @max_network_retries = val.to_i
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
      :uname => @uname,
      :hostname => Socket.gethostname,
      :engine => defined?(RUBY_ENGINE) ? RUBY_ENGINE : '',
      :openssl_version => OpenSSL::OPENSSL_VERSION
    }

  end

  def self.get_uname
    if File.exist?('/proc/version')
      File.read('/proc/version').strip
    else
      case RbConfig::CONFIG['host_os']
      when /linux|darwin|bsd|sunos|solaris|cygwin/i
        _uname_uname
      when /mswin|mingw/i
        _uname_ver
      else
        "unknown platform"
      end
    end
  end

  def self._uname_uname
    (`uname -a 2>/dev/null` || '').strip
  rescue Errno::ENOMEM
    "uname lookup failed"
  end

  def self._uname_ver
    (`ver` || '').strip
  rescue Errno::ENOMEM
    "uname lookup failed"
  end

  def self.execute_request_with_rescues(request_opts, api_base_url, retry_count = 0)
    begin
      response = execute_request(request_opts)

    rescue => e
      if should_retry?(e, retry_count)
        retry_count = retry_count + 1
        sleep sleep_time(retry_count)
        retry
      end

      case e
      when SocketError
        response = handle_restclient_error(e, request_opts, retry_count, api_base_url)

      when RestClient::ExceptionWithResponse
        if e.response
          handle_api_error(e.response)
        else
          response = handle_restclient_error(e, request_opts, retry_count, api_base_url)
        end

      when RestClient::Exception, Errno::ECONNREFUSED, OpenSSL::SSL::SSLError
        response = handle_restclient_error(e, request_opts, retry_count, api_base_url)

      else
        raise
      end
    end

    response
  end

  def self.request_headers(api_key, method_sym, data, url)
    post_or_put = (method_sym == :post or method_sym == :put)
    headers = {
      :user_agent => "Pingpp/v1 RubyBindings/#{Pingpp::VERSION}",
      :authorization => "Bearer #{api_key}",
      :content_type => post_or_put ? 'application/json' : 'application/x-www-form-urlencoded'
    }

    headers[:pingplusplus_version] = api_version if api_version
    headers.update(parsed_headers) if parsed_headers && !parsed_headers.empty?

    begin
      headers.update(:x_pingpp_client_user_agent => JSON.generate(user_agent))
    rescue => e
      headers.update(:x_pingpp_client_raw_user_agent => user_agent.inspect,
                     :error => "#{e} (#{e.class})")
    end

    data_to_be_signed = data || ''
    uri = URI.parse(url)
    data_to_be_signed += uri.path
    (!uri.query.nil?) && data_to_be_signed += '?' + uri.query

    request_time = Time.now.to_i.to_s
    headers.update(:pingplusplus_request_timestamp => request_time)
    data_to_be_signed += request_time

    if private_key
      signature = sign_request(data_to_be_signed, private_key)
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

  def self.pub_key_path=(pub_key_path)
    @pub_key = File.read(pub_key_path)
  end

  def self.sign_request(data, pri_key)
    pkey = OpenSSL::PKey.read(pri_key)
    return Base64.strict_encode64(pkey.sign(OpenSSL::Digest::SHA256.new, data))
  end

  def self.general_api_error(rcode, rbody)
    APIError.new("Invalid response object from API: #{rbody.inspect} " +
                 "(HTTP response code was #{rcode})", rcode, rbody)
  end

  def self.handle_api_error(resp)
    begin
      error_obj = JSON.parse(resp.body)
      error_obj = Util.symbolize_names(error_obj)
      error = error_obj[:error]
      raise PingppError.new unless error && error.is_a?(Hash)

    rescue JSON::ParserError, PingppError
      raise general_api_error(resp.code, resp.body)
    end

    case resp.code
    when 400, 404
      raise invalid_request_error(error, resp, error_obj)
    when 401
      raise authentication_error(error, resp, error_obj)
    when 402
      raise channel_error(error, resp, error_obj)
    when 403
      raise rate_limit_error(error, resp, error_obj)
    else
      raise api_error(error, resp, error_obj)
    end

  end

  def self.invalid_request_error(error, resp, error_obj)
    InvalidRequestError.new(error[:message], error[:param], resp.code,
                            resp.body, error_obj, resp.headers)
  end

  def self.authentication_error(error, resp, error_obj)
    AuthenticationError.new(error[:message], resp.code, resp.body, error_obj,
                            resp.headers)
  end

  def self.channel_error(error, resp, error_obj)
    ChannelError.new(error[:message], error[:code], error[:param], resp.code,
                     resp.body, error_obj, resp.headers)
  end

  def self.rate_limit_error(error, resp, error_obj)
    RateLimitError.new(error[:message], resp.code, resp.body, error_obj,
                       resp.headers)
  end

  def self.api_error(error, resp, error_obj)
    APIError.new(error[:message], resp.code, resp.body, error_obj, resp.headers)
  end

  def self.handle_restclient_error(e, request_opts, retry_count, api_base_url=nil)
    api_base_url = @api_base unless api_base_url

    connection_message = "Please check your internet connection and try again. " \
        "If this problem persists, you should check Pingpp's service status at " \
        "https://www.pingxx.com/status"

    case e
    when RestClient::RequestTimeout
      message = "Could not connect to Pingpp (#{api_base_url}). #{connection_message}"

    when RestClient::ServerBrokeConnection
      message = "The connection to the server (#{api_base_url}) broke before the " \
        "request completed. #{connection_message}"

    when OpenSSL::SSL::SSLError
      message = "Could not establish a secure connection to Ping++, you may " \
                "need to upgrade your OpenSSL version. To check, try running " \
                "'openssl s_client -connect api.pingxx.com:443' from the " \
                "command line."

    when RestClient::SSLCertificateNotVerified
      message = "Could not verify Pingpp's SSL certificate. " \
        "Please make sure that your network is not intercepting certificates. " \
        "(Try going to (#{api_base_url}) in your browser.)"

    when SocketError
      message = "Unexpected error communicating when trying to connect to Pingpp. " \
        "You may be seeing this message because your DNS is not working. " \
        "To check, try running 'host pingxx.com' from the command line."

    else
      message = "Unexpected error communicating with Pingpp."

    end

    if retry_count > 0
      message += " Request was retried #{retry_count} times."
    end

    raise APIConnectionError.new(message + "\n\n(Network error: #{e.message})")
  end

  def self.should_retry?(e, retry_count)
    retry_count < self.max_network_retries &&
      RETRY_EXCEPTIONS.any? { |klass| e.is_a?(klass) }
  end

  def self.sleep_time(retry_count)
    sleep_seconds = [initial_network_retry_delay * (2 ** (retry_count - 1)), max_network_retry_delay].min
    sleep_seconds = sleep_seconds * (0.5 * (1 + rand()))
    sleep_seconds = [initial_network_retry_delay, sleep_seconds].max

    sleep_seconds
  end
end
