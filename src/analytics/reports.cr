require "base64"
require "connect-proxy"
require "../auth/file_auth"

module Google::Analytics
  ANALYTICS_URI = URI.parse("")

  class Reporting
    def initialize(@auth : Google::Auth | String)
    end

    # API details: https://developers.google.com/analytics/devguides/reporting/core/v4
    # example: https://developers.google.com/analytics/devguides/reporting/core/v4/quickstart/service-py
    # requires scope: https://www.googleapis.com/auth/analytics.readonly
    def send_request(user_id)
      view_id =

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
