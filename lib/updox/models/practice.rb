module Updox
  module Models
    class Practice < Hashie::Trash
      CREATE_ENDPOINT = '/practiceCreate'.freeze
      QUERY_ENDPOINT  = '/practiceList'.freeze

      include Hashie::Extensions::IndifferentAccess

      property :name, required: true
      property :active, default: false
      property :accountId, from: :account_id, with: ->(v) { v.to_s }
      property :address1
      property :address2
      property :city
      property :state
      property :postal
      property :phone
      property :fax
      property :websiteAddress, from: :website_address
      property :timeZone, from: :time_zone
      property :directDomain, from: :direct_domain
      property :directAddress, from: :direct_address
      property :protocol
      property :ipAddress, from: :ip_address
      property :port
      property :path
      property :metadata
      property :practiceSpecialtyCode, from: :practice_specialty_code
      property :practiceNpi, from: :practice_npi
      property :defaultConsentMethods

      alias_method :account_id, :accountId

      def create
        UpdoxClient.connection.request(endpoint: CREATE_ENDPOINT, body: self.to_h, required_auths: Updox::Models::Auth::AUTH_APP)
      end

      def self.query
        UpdoxClient.connection.request(endpoint: QUERY_ENDPOINT, required_auths: Updox::Models::Auth::AUTH_APP)
      end
    end
  end
end
