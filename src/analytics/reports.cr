require "base64"
require "connect-proxy"
require "../auth/file_auth"

module Google::Analytics
  ANALYTICS_URI = URI.parse("")

  class Reporting
    def initialize(@auth : Google::Auth | String)
    end

    # API details: https://developers.google.com/gmail/api/reference/rest/v1/users.messages/send
    # sending a RAW RFC 2822 email: https://developers.google.com/gmail/api/reference/rest/v1/users.messages#Message
    # requires scope: https://www.googleapis.com/auth/gmail.send
    def send_request(user_id)
      email = Base64.strict_encode(email)

      HTTP::Request.new(
        "POST",
        "endpoint",
        HTTP::Headers{
          "Authorization" => "Bearer #{get_token}",
          "Content-Type"  => "application/json",
        },
        {raw: }.to_json
      )
    end

    private def get_token : String
      auth = @auth
      case auth
      in Google::Auth
        auth.get_token.access_token
      in String
        auth
      end
    end

    private def perform(request)
      ConnectProxy::HTTPClient.new(ANALYTICS_URI) do |client|
        client.exec(request)
      end
    end
  end
end
