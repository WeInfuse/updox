module Updox
  module Models
    class Location < Model
      SYNC_ENDPOINT  = '/LocationsSync'.freeze

      property :id
      property :code
      property :name
      property :showInPortal, default: false, from: :show_in_portal, with: ->(v) { true == v }, transform_with: ->(v) { true == v }
      property :active, default: true

      def save(account_id: )
        self.class.sync([self], account_id: account_id)
      end

      def self.sync(locations, account_id: )
        from_response(UpdoxClient.connection.request(endpoint: SYNC_ENDPOINT, body: { locations: locations }, auth: {accountId: account_id}, required_auths: Updox::Models::Auth::AUTH_ACCT), self)
      end
    end
  end
end
