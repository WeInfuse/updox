module Updox
  module Models
    class User < Model
      SAVE_ENDPOINT  = '/UserSave'.freeze
      QUERY_ENDPOINT = '/UserList'.freeze

      LIST_TYPE = 'userList'.freeze
      LIST_NAME = 'users'

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
      property :provider, default: false
      property :admin, default: false
      property :searchOptOut, from: :search_opt_out, default: true

      alias_method :user_id, :userId
      alias_method :first_name, :firstName
      alias_method :last_name, :lastName

      def create
        UpdoxClient.connection.request(endpoint: SAVE_ENDPOINT, body: self.to_h, required_auths: Updox::Models::Auth::AUTH_APP)
      end

      def self.query
        from_response(UpdoxClient.connection.request(endpoint: QUERY_ENDPOINT, required_auths: Updox::Models::Auth::AUTH_APP), self)
      end
    end
  end
end
