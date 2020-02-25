module Updox
  module Models
    class PatientMessage < Model
      LIST_ENDPOINT  = '/PatientMessageCountSince'.freeze

      def self.query(patient_id, account_id: )
        request(endpoint: LIST_ENDPOINT, body: { patientId: patient_id }, auth: {accountId: account_id}, required_auths: Updox::Models::Auth::AUTH_ACCT)
      end

      def self.exists?(patient_id, account_id: )
        request(endpoint: LIST_ENDPOINT, body: { patientId: patient_id }, auth: {accountId: account_id}, required_auths: Updox::Models::Auth::AUTH_ACCT).successful?
      end
    end
  end
end
