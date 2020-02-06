module Updox
  module Models
    class Calendar < Model
      SYNC_ENDPOINT = '/CalendarsSync'.freeze

      property :id, required: true
      property :title, required: true
      property :color, required: true, default: '#000000'
      property :textColor, required: true, default: '#FFFFFF'
      property :publicCalendar, default: false, from: :public_calendar, with: ->(v) { true == v}, transform_with: ->(v) { true == v }
      property :active, default: true
      property :reminderTurnOff, default: false, from: :reminder_turn_off, with: ->(v) { true == v}, transform_with: ->(v) { true == v }

      def create(account_id: )
        self.class.from_response(UpdoxClient.connection.request(endpoint: SYNC_ENDPOINT, body: self.to_h, auth: {accountId: account_id}, required_auths: Updox::Models::Auth::AUTH_ACCT))
      end
    end
  end
end
