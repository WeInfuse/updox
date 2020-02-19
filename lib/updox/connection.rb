module Updox
  class Connection
    TEST_HOST = 'updoxqa.com'
    PROD_HOST = 'xxxxxxx.com'

    include HTTParty

    base_uri "https://#{TEST_HOST}/api/io/".freeze

    headers 'Content-Type' => 'application/json'

    format :json

    def request(endpoint: Updox::Models::Auth::PING_ENDPOINT, body: {}, headers: {}, auth: Updox::Models::Auth.new, required_auths: [], account_id: nil, user_id: nil)
      if body.is_a?(Hash)
        auth[:accountId] = account_id unless account_id.nil?
        auth[:userId]    = user_id unless user_id.nil?

        body = auth_data(auth, required_auths).merge(body)
        body = body.to_json
      end

      self.class.post(endpoint, body: body, headers: headers)
    end

    private
    def auth_data(auth, required_auths)
      result_auth = auth.dup

      if required_auths.any?
        result_auth = Updox::Models::Auth.new(
          application_id: Updox.configuration.application_id,
          application_password: Updox.configuration.application_password
        ).merge(result_auth)
      end

      result_auth = result_auth.keep_if {|k, v| required_auths.include?(k) }

      result_auth.to_h
    end
  end
end
