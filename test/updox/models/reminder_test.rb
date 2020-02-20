require 'test_helper'

class ReminderTest < Minitest::Test
  describe 'appointment' do
    let(:reminder) { Updox::Models::Reminder.new(reminder_json) }
    let(:reminder_json) {
      load_sample('appointment_statuses.response.json', parse: true).dig('appointmentStatuses').first.dig('reminders').first
    }

    describe 'object' do
      describe 'serializes' do
        it 'can serialize to json' do
          assert_kind_of(Date, reminder.date)
          assert_equal(2, reminder.date.month)
          assert_equal(8, reminder.date.day)
          assert_equal(2020, reminder.date.year)
        end

        describe 'empty date' do
          let(:reminder_json) {
            load_sample('appointment_statuses.response.json', parse: true).dig('appointmentStatuses').first.dig('reminders').last
          }

          it 'handles empty date' do
            assert_nil(reminder.date)
          end
        end
      end
    end
  end
end
