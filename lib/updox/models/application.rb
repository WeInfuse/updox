module Updox
  module Models
    class Application < Model
      OPEN_ENDPOINT = '/ApplicationOpen'.freeze

      property :ipAddress, from: :ip_address
      property :timeout
      property :metadata

      alias_method :ip_address, :ipAddress

      def url(account_id: , user_id: , base_uri: nil)
        response = self.open(account_id: account_id, user_id: user_id)

        base_uri ||= Updox.configuration.api_endpoint.split(URI.parse(Updox.configuration.api_endpoint).path).first

        "#{base_uri}/sso/applicationOpen/#{Updox.configuration.application_id}/#{response.item.dig('token')}"
      end

      def open(account_id: , user_id: )
        Model.from_response(UpdoxClient.connection.request(endpoint: OPEN_ENDPOINT, auth: {accountId: account_id, userId: user_id}, required_auths: Updox::Models::Auth::AUTH_FULL))
      end
    end
  end
end
