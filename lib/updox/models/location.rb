module Updox
  module Models
    class Location < Hashie::Trash
      SYNC_ENDPOINT  = '/locationsSync'.freeze

      include Hashie::Extensions::IndifferentAccess

      property :id
      property :code
      property :name
      property :showInPortal, default: false, from: :show_in_portal, with: ->(v) { true == v }, transform_with: ->(v) { true == v }
      property :active, default: false, transform_with: ->(v) { true == v }

      def self.sync(locations, account_id: )
        UpdoxClient.connection.request(endpoint: SYNC_ENDPOINT, body: { locations: locations }, auth: {accountId: account_id}, required_auths: Updox::Models::Auth::AUTH_ACCT)
      end
    end
  end
end
