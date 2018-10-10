require 'base64'
require 'forwardable'

module BraspagRest
  class TokenManager
    include Singleton

    class << self
      extend Forwardable
      def_delegators :instance, :token
    end

    def token
      "Bearer #{access_token}"
    end

    private

    def access_token
      request_token unless token_valid?
      @token_info[:access_token]
    end

    def request_token
      response = JSON.parse(RestClient::Request.execute(
                              method: :post,
                              url: oauth2_url,
                              payload: 'grant_type=client_credentials',
                              headers: default_headers
                            ))
      @token_info = { access_token: response['access_token'], expires_in: Time.now + (response['expires_in'].to_i - 120) }
    end

    def default_headers
      { 'Content-Type' => 'application/x-www-form-urlencoded', 'Authorization' => encoded_credentials }
    end

    def encoded_credentials
      encoded = Base64.strict_encode64("#{BraspagRest.config.client_id}:#{BraspagRest.config.client_secret}")
      "Basic #{encoded}"
    end

    def oauth2_url
      BraspagRest.config.oauth2_url
    end

    def token_valid?
      @token_info && !expired?
    end

    def expired?
      @token_info[:expires_in] < Time.now
    end
  end
end
