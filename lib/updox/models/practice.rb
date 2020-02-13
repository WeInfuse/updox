module Updox
  module Models
    class Practice < Model
      CREATE_ENDPOINT = '/PracticeCreate'.freeze
      FIND_ENDPOINT   = '/PracticeGet'.freeze
      QUERY_ENDPOINT  = '/PracticeList'.freeze

      LIST_TYPE = 'practiceList'.freeze
      LIST_NAME = 'practices'
      ITEM_TYPE = 'practice'

      property :name, required: true
      property :accountId, from: :account_id, with: ->(v) { v.to_s }
      property :address1
      property :address2
      property :city
      property :state
      property :postal, from: :zip
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
      property :active, default: true

      alias_method :account_id, :accountId
      alias_method :zip, :postal

      def create
        UpdoxClient.connection.request(endpoint: CREATE_ENDPOINT, body: self.to_h, required_auths: Updox::Models::Auth::AUTH_APP)
      end

      def self.exists?(account_id)
        self.find(account_id).successful?
      end

      def self.find(account_id)
        from_response(UpdoxClient.connection.request(endpoint: FIND_ENDPOINT, body: {accountId: account_id}, required_auths: Updox::Models::Auth::AUTH_APP))
      end

      def self.query
        from_response(UpdoxClient.connection.request(endpoint: QUERY_ENDPOINT, required_auths: Updox::Models::Auth::AUTH_APP))
      end
    end
  end
end
