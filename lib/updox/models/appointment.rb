module Updox
  module Models
    class Appointment < Model
      extend Updox::Models::Extensions::Sync

      SYNC_ENDPOINT  = '/AppointmentsSync'.freeze

      SYNC_LIST_TYPE = 'appointments'.freeze

      property :id, required: true
      property :updoxId, from: :updox_id
      property :calendarId, required: true, from: :calendar_id
      property :date, required: true
      property :duration
      property :patientId, from: :patient_id
      property :typeId, from: :type_id
      property :summary
      property :details
      property :blocked, required: true, default: false
      property :cancelled, required: true, from: :canceled, default: false
      property :locationId, from: :location_id
      property :reminderTokens, from: :reminder_tokens

      alias_method :updox_id, :updoxId
      alias_method :calendar_id, :calendarId
      alias_method :patient_id, :patientId
      alias_method :type_id, :typeId
      alias_method :location_id, :locationId
      alias_method :reminder_tokens, :reminderTokens
      alias_method :canceled, :cancelled

      def to_h
        result = super.to_h

        result['date'] = result['date'].strftime(Updox::Models::DATETIME_FORMAT) if result['date'].respond_to?(:strftime)

        result
      end

      def save(account_id: )
        self.class.sync([self], account_id: account_id)
      end

      def self.exists?(appointment_id, account_id: , cached_query: nil)
        Updox::Models::AppointmentStatus.exists?(appointment_id, account_id: account_id, cached_query: cached_query)
      end
    end
  end
end
