module Updox
  module Models
    class Reminder < Model
      property :reminderId
      property :reminderStatus
      property :reminderStatusDate, transform_with: ->(v) { DateTime.strptime(v, DATETIME_OTHER_FORMAT) unless v.nil? || v.empty? }
      property :reminderType

      alias_method :reminder_id, :reminderId
      alias_method :reminder_status, :reminderStatus
      alias_method :reminder_status_date, :reminderStatusDate
      alias_method :reminder_type, :reminderType
      alias_method :id, :reminderId
      alias_method :date, :reminderStatusDate
      alias_method :status, :reminderStatus
      alias_method :type, :reminderType
    end
  end
end
