module Updox
  class Connection
    include HTTParty

    base_uri 'http://updoxqa.com/api/io/'.freeze

    headers 'Content-Type' => 'application/json'

    format :json

    def request(endpoint: '/ping', body: {}, headers: {}, auth: true)
      if body.is_a?(Hash)
        body = auth_data(auth).merge(body)
        body = body.to_json
      end

      self.class.post(endpoint, body: body, headers: headers)
    end

    private
    def auth_data(include_auth = true)
      if include_auth
        Updox::Models::Auth.build_auth(application_id: Updox.configuration.application_id, application_password: Updox.configuration.application_password)
      else
        Updox::Models::Auth.build_auth()
      end
    end
  end
end
