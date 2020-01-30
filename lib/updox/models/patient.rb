module Updox
  module Models
    class Patient < Hashie::Trash
      SYNC_ENDPOINT  = '/patientsSync'.freeze

      include Hashie::Extensions::IndifferentAccess

      property :id
      property :internalId, required: true, from: :internal_id
      property :firstName, from: :first_name
      property :middleName, from: :middle_name
      property :lastName, from: :last_name
      property :emailAddress, from: :email_address
      property :homePhone, from: :home_phone
      property :workPhone, from: :work_phone
      property :mobileNumber, from: :mobile_number
      property :active, default: false, transform_with: ->(v) { true == v }

      def self.sync(patients, account_id: )
        UpdoxClient.connection.request(endpoint: SYNC_ENDPOINT, body: { patients: patients }, auth: {accountId: account_id}, required_auths: Updox::Models::Auth::AUTH_ACCT)
      end
    end
  end
end
