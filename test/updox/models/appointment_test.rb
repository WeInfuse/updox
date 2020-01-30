require 'test_helper'

class AppointmentTest < Minitest::Test
  describe 'appointment' do
    let(:appointment) { Updox::Models::Appointment.new(id: '123', calendar_id: 'cal009', date: Time.now) }
    let(:account_id) { 'account_0001' }

    describe 'object' do
      describe 'serializes' do
        it 'can serialize to json' do
          result = JSON.parse(appointment.to_h.to_json)

          assert_equal(appointment.date.strftime(Updox::Models::DATETIME_FORMAT), result['date'])
        end
      end
    end

    describe 'sync' do
      before do
        stub_updox(endpoint: Updox::Models::Appointment::SYNC_ENDPOINT, response: build_response())

        WebMock.after_request do |request, response|
          @request = request
        end

        appointment.class.sync([appointment], account_id: account_id)
      end

      it 'calls sync api' do
        request_body = JSON.parse(@request.body)

        assert_equal(request_body['appointments'].first, appointment.to_h)
      end

      it 'has acct auth' do
        assert_acct_auth(@request, account_id)
      end
    end
  end
end
