module Updox
  module Models
    class Patient < Model
      extend Updox::Models::Extensions::Sync

      SYNC_ENDPOINT  = '/PatientsSync'.freeze
      SYNC_LIST_TYPE = 'patients'.freeze

      REMINDER_PREFERENCES = {
        practice: 0,
        email: 1,
        home_phone: 2,
        mobile_phone: 3,
        mobile_text: 4,
        off: 5
      }

      property :id
      property :internalId, required: true, from: :internal_id
      property :firstName, from: :first_name
      property :middleName, from: :middle_name
      property :lastName, from: :last_name
      property :emailAddress, from: :email
      property :emailAddress, from: :email_address
      property :homePhone, from: :home_phone
      property :workPhone, from: :work_phone
      property :mobileNumber, from: :mobile_number
      property :mobileNumber, from: :mobile_phone
      property :reminderMethodId, from: :reminder_method_id
      property :active, default: true

      alias_method :email, :emailAddress
      alias_method :email_address, :emailAddress
      alias_method :internal_id, :internalId
      alias_method :first_name, :firstName
      alias_method :middle_name, :middleName
      alias_method :last_name, :lastName
      alias_method :home_phone, :homePhone
      alias_method :work_phone, :workPhone
      alias_method :mobile_number, :mobileNumber
      alias_method :mobile_phone, :mobileNumber
      alias_method :reminder_preference, :reminderMethodId

      def reminder_preference=(value)
        if Updox::Models::Patient::REMINDER_PREFERENCES.include?(value)
          self[:reminderMethodId] = Updox::Models::Patient::REMINDER_PREFERENCES[value]
        else
          self[:reminderMethodId] = value
        end

        self
      end

      def save(account_id: )
        self.class.sync([self], account_id: account_id)
      end

      def self.exists?(patient_id, account_id: )
        Updox::Models::PatientMessage.exists?(patient_id, account_id: account_id)
      end
    end
  end
end
