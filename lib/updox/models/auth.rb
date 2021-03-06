module Updox
  module Models
    class Auth < Hashie::Trash
      AUTH_NONE = []
      AUTH_APP  = [:applicationId, :applicationPassword]
      AUTH_ACCT = AUTH_APP + [:accountId]
      AUTH_FULL = AUTH_ACCT + [:userId]

      PING_ENDPOINT = '/Ping'
      PING_APP_ENDPOINT = PING_ENDPOINT + 'WithApplicationAuth'
      PING_ACCT_ENDPOINT = PING_ENDPOINT + 'WithAccountAuth'
      PING_FULL_ENDPOINT = PING_ENDPOINT + 'WithAuth'

      property :applicationId, from: :application_id
      property :applicationPassword, from: :application_password
      property :accountId, from: :account_id
      property :userId, from: :user_id

      alias_method :application_id, :applicationId
      alias_method :application_password, :applicationPassword
      alias_method :account_id, :accountId
      alias_method :user_id, :userId

      def to_h
        { auth: super.to_h }
      end

      def ping
        Model.request(endpoint: PING_ENDPOINT, auth: self)
      end

      def ping_with_application_auth
        Model.request(endpoint: PING_APP_ENDPOINT, auth: self, required_auths: AUTH_APP)
      end

      def ping_with_account_auth
        Model.request(endpoint: PING_ACCT_ENDPOINT, auth: self, required_auths: AUTH_ACCT)
      end

      def ping_with_full_auth
        Model.request(endpoint: PING_FULL_ENDPOINT, auth: self, required_auths: AUTH_FULL)
      end
    end
  end
end
