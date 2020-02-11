module Updox
  module Models
    class Calendar < Model
      SYNC_ENDPOINT = '/CalendarsSync'.freeze

      property :id, required: true
      property :title, required: true
      property :color, required: true, default: '#2DA2C8'
      property :textColor, required: true, from: :text_color, default: '#FFFFFF'
      property :publicCalendar, default: false, from: :public_calendar
      property :active, default: true
      property :reminderTurnOff, default: false, from: :reminder_turn_off

      alias_method :text_color, :textColor
      alias_method :public_calendar, :publicCalendar
      alias_method :reminder_turn_off, :reminderTurnOff

      def create(account_id: )
        self.class.from_response(UpdoxClient.connection.request(endpoint: SYNC_ENDPOINT, body: self.to_h, auth: {accountId: account_id}, required_auths: Updox::Models::Auth::AUTH_ACCT))
      end
    end
  end
end
