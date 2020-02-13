module Updox
  module Models
    class Location < Model
      SYNC_ENDPOINT  = '/LocationsSync'.freeze
      LIST_ENDPOINT  = '/PracticeLocationsRetrieve'.freeze

      LIST_TYPE = 'locations'
      LIST_NAME = LIST_TYPE

      property :id
      property :code
      property :name
      property :address1
      property :address2
      property :city
      property :state
      property :zip
      property :dayphone, from: :phone
      property :evephone
      property :faxphone, from: :fax
      property :apptphone
      property :emailAddress, from: :email
      property :emailAddress, from: :email_address
      property :showInPortal, default: false, from: :show_in_portal
      property :active, default: true

      # This is only on response
      property :external_id, from: :externalId

      alias_method :show_in_portal, :showInPortal
      alias_method :phone, :dayphone
      alias_method :fax, :faxphone
      alias_method :email, :emailAddress
      alias_method :email_address, :emailAddress

      def save(account_id: )
        self.class.sync([self], account_id: account_id)
      end

      def self.exists?(location_id, account_id: , cached_query: nil)
        false == self.find(location_id, account_id: account_id, cached_query: cached_query).nil?
      end

      def self.find(location_id, account_id: , cached_query: nil)
        obj = cached_query || self.query(account_id: account_id)

        obj.locations.find {|location| location_id.to_s == location.external_id.to_s }
      end

      def self.query(account_id: , active_only: false)
        request(endpoint: LIST_ENDPOINT, body: { activeOnly: active_only }, auth: {accountId: account_id}, required_auths: Updox::Models::Auth::AUTH_ACCT)
      end

      def self.sync(locations, account_id: )
        request(endpoint: SYNC_ENDPOINT, body: { locations: locations }, auth: {accountId: account_id}, required_auths: Updox::Models::Auth::AUTH_ACCT)
      end
    end
  end
end
