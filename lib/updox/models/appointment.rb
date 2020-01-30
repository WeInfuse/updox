module Updox
  module Models
    class Appointment < Hashie::Trash
      SYNC_ENDPOINT  = '/appointmentsSync1_1'.freeze

      include Hashie::Extensions::IndifferentAccess

      property :id, required: true
      property :updoxId, from: :updox_id
      property :calendarId, required: true, from: :calendar_id
      property :date, required: true
      property :duration
      property :patientId
      property :typeId
      property :summary
      property :details
      property :blocked, required: true, transform_with: ->(v) { true == v }, default: false
      property :cancelled, required: true, transform_with: ->(v) { true == v }, default: false
      property :locationId, from: :location_id
      property :reminderTokens, from: :reminder_tokens

      def to_h
        result = super.to_h

        result['date'] = result['date'].strftime(Updox::Models::DATETIME_FORMAT) if result['date'].respond_to?(:strftime)

        result
      end

      def self.sync(appointments, account_id: )
        UpdoxClient.connection.request(endpoint: SYNC_ENDPOINT, body: { appointments: appointments.map(&:to_h) }, auth: {accountId: account_id}, required_auths: Updox::Models::Auth::AUTH_ACCT)
      end
    end
  end
end
