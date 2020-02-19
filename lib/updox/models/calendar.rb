module Updox
  module Models
    class Calendar < Model
      SYNC_ENDPOINT = '/CalendarsSync'.freeze
      LIST_ENDPOINT  = '/PracticeCalendarsRetrieve'.freeze

      LIST_TYPE = 'calendars'
      LIST_NAME = LIST_TYPE

      property :id, required: true
      property :title, required: true
      property :color, required: true, default: '#3AC'
      property :textColor, required: true, from: :text_color, default: '#000'
      property :publicCalendar, default: false, from: :public_calendar
      property :active, default: true
      property :reminderTurnOff, default: false, from: :reminder_turn_off

      # This is only on response
      property :external_id, from: :externalId

      alias_method :text_color, :textColor
      alias_method :public_calendar, :publicCalendar
      alias_method :reminder_turn_off, :reminderTurnOff

      def create(account_id: )
        self.class.request(endpoint: SYNC_ENDPOINT, body: self.to_h, auth: {accountId: account_id}, required_auths: Updox::Models::Auth::AUTH_ACCT)
      end

      def self.find(calendar_id, account_id: , cached_query: nil)
        obj = cached_query || self.query(account_id: account_id)

        obj.calendars.find {|calendar| calendar_id.to_s == calendar.external_id.to_s }
      end

      def self.query(account_id: , active_only: false)
        request(endpoint: LIST_ENDPOINT, body: { activeOnly: active_only }, auth: {accountId: account_id}, required_auths: Updox::Models::Auth::AUTH_ACCT)
      end
    end
  end
end
