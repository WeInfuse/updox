module Updox
  module Models
    class User < Model
      extend Updox::Models::Extensions::Exists

      SAVE_ENDPOINT  = '/UserSave'.freeze
      QUERY_ENDPOINT = '/UserList'.freeze
      FIND_ENDPOINT  = '/UserGet'.freeze

      LIST_TYPE = 'userList'.freeze
      LIST_NAME = 'users'
      ITEM_TYPE = 'user'

      property :userId, from: :user_id
      property :emrUserId, from: :emr_user_id
      property :loginId, from: :login_id
      property :loginPassword, from: :login_password
      property :firstName, required: true, from: :first_name
      property :middleName, from: :middle_name
      property :lastName, required: true, from: :last_name
      property :address1
      property :address2
      property :city
      property :state
      property :postal
      property :timeZone, from: :time_zone
      property :metadata
      property :vetted
      property :active, default: true
      property :searchOptOut, from: :search_opt_out, default: true
      property :npi
      property :providerTaxonomyCode, from: :provider_taxonomy_code
      property :directAddress, from: :direct_address
      property :provider, default: false
      property :admin, default: false

      alias_method :user_id, :userId
      alias_method :first_name, :firstName
      alias_method :last_name, :lastName
      alias_method :login_password, :loginPassword
      alias_method :time_zone, :timeZone
      alias_method :provider_taxonomy_code, :providerTaxonomyCode
      alias_method :direct_address, :directAddress

      def create(account_id: )
        self.class.request(endpoint: SAVE_ENDPOINT, body: self.to_h, auth: {accountId: account_id}, required_auths: Updox::Models::Auth::AUTH_ACCT)
      end

      def self.find(user_id, account_id: )
        response = request(endpoint: FIND_ENDPOINT, account_id: account_id, body: { userId: user_id}, required_auths: Updox::Models::Auth::AUTH_ACCT)

        if response.successful?
          response
        else
          nil
        end
      end

      def self.query
        request(endpoint: QUERY_ENDPOINT, required_auths: Updox::Models::Auth::AUTH_APP)
      end
    end
  end
end
