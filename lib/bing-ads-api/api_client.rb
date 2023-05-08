module BingAdsApi

  class ApiClient

    REDIRECT_URI = "https://login.microsoftonline.com/common/oauth2/nativeclient"
    SCOPE = "https://ads.microsoft.com/msads.manage"
    TOKEN_URL = 'https://login.microsoftonline.com/common/oauth2/v2.0/token'

    attr_accessor :auth_url, :refresh_token, :code, :authentication_token

    def initialize(client_id)
      @client_id = client_id
      auth_url = "https://login.microsoftonline.com/common/oauth2/v2.0/authorize?client_id=#{@client_id}&response_type=code&scope=https%3A%2F%2Fads.microsoft.com%2Fmsads.manage%20offline_access&redirect_uri=#{REDIRECT_URI}&state=#{Time.now.to_i}"
      self.auth_url = auth_url
    end

    def fetch_authentication_token!
      params = {
        client_id: @client_id,
        scope: SCOPE,
        grant_type: 'refresh_token',
        redirect_uri: REDIRECT_URI,
        refresh_token: self.refresh_token
      }
      options = { body: params }
      result = HTTParty.post(TOKEN_URL, options)
      if result.parsed_response['access_token']
        self.authentication_token = result.parsed_response['access_token']
      end
    end

    def fetch_refresh_token!
      params = {
        client_id: @client_id,
        scope: SCOPE,
        code: self.code,
        grant_type: 'authorization_code',
        redirect_uri: REDIRECT_URI
      }
      options = { body: params }
      result = HTTParty.post(TOKEN_URL, options)
      if result.parsed_response['refresh_token']
        self.refresh_token = result.parsed_response['refresh_token']
        self.authentication_token = result.parsed_response['access_token']
      end
    end

    def generate_auth_url_for_code
      "https://login.microsoftonline.com/common/oauth2/v2.0/authorize?client_id=#{@client_id}&response_type=code&scope=https%3A%2F%2Fads.microsoft.com%2Fmsads.manage%20offline_access&redirect_uri=https://login.microsoftonline.com/common/oauth2/nativeclient"
    end
  end
end
