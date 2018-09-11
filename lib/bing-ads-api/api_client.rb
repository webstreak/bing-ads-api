module BingAdsApi

  class ApiClient

    REDIRECT_URI = "https://login.microsoftonline.com/common/oauth2/nativeclient"

    attr_accessor :auth_url, :refresh_token, :code

    def initialize(client_id)
      @client_id = client_id
      self.auth_url = "https://login.live.com/oauth20_authorize.srf?client_id=#{@client_id}&scope=bingads.manage&response_type=code&redirect_uri=#{REDIRECT_URI}&state=#{Time.now.to_i}"
    end

    def fetch_access_token!
      params = {
        client_id: @client_id,
        scope: 'bingads.manage',
        code: self.code,
        grant_type: 'authorization_code',
        redirect_uri: REDIRECT_URI
      }
      headers= {
        "Accept" => "application/json",
        "Content-Type" => "application/x-www-form-urlencoded",
        "Host" => "login.live.com",
      }
      options = { body: params }
      result = HTTParty.post("https://login.live.com/oauth20_token.srf", options)
      if result.parsed_response['refresh_token']
        self.refresh_token = result.parsed_response['refresh_token']
      end
    end

  end

end
