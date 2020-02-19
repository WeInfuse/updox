module Updox
  module Models
    class AppointmentStatus < Model
      LIST_ENDPOINT  = '/AppointmentStatusesGetByIds'.freeze

      LIST_TYPE = 'appointmentStatuses'
      LIST_NAME = 'statuses'

      property :appointmentId
      property :externalAppointmentId
      property :appointmentStatus
      property :reminders, transform_with: ->(list) { list.map {|item| Updox::Models::Reminder.new(item) } }

      alias_method :appointment_id, :appointmentId
      alias_method :external_appointment_id, :externalAppointmentId
      alias_method :appointment_status, :appointmentStatus

      def self.find(appointment_id, account_id: , cached_query: nil)
        obj = cached_query || self.query([appointment_id], account_id: account_id)

        obj.statuses.find {|status| appointment_id.to_s == status.external_appointment_id.to_s }
      end

      def self.query(appointment_ids, account_id: , active_only: false)
        request(endpoint: LIST_ENDPOINT, body: { appointmentIds: appointment_ids }, auth: {accountId: account_id}, required_auths: Updox::Models::Auth::AUTH_ACCT)
      end
    end
  end
end
