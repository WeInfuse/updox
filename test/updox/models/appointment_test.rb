require 'test_helper'

class AppointmentTest < Minitest::Test
  describe 'appointment' do
    let(:appointment) { Updox::Models::Appointment.new(id: '123', calendar_id: 'cal009', date: Time.now) }
    let(:account_id) { 'account_0001' }
    let(:appt_id) { '123' }

    describe 'object' do
      describe 'serializes' do
        it 'can serialize to json' do
          result = JSON.parse(appointment.to_h.to_json)

          assert_equal(appointment.date.strftime(Updox::Models::DATETIME_FORMAT), result['date'])
        end
      end
    end

    describe 'api' do
      before do
        stub_updox(endpoint: ep, response: response)

        WebMock.after_request do |request|
          @request = request
        end
      end

      describe 'sync' do
        let(:response) { nil }
        let(:ep) { Updox::Models::Appointment::SYNC_ENDPOINT }

        before do
          appointment.save(account_id: account_id)
        end

        it 'calls sync api' do
          assert_equal(1, request_body['appointments'].size)
          assert_equal(appointment.to_h, request_body['appointments'].first)
        end

        it 'has bulk call' do
          appointment.class.sync([appointment, appointment], account_id: account_id)

          assert_equal(2, request_body['appointments'].size)
          assert_equal(appointment.to_h, request_body['appointments'].first)
        end

        it 'has acct auth' do
          assert_acct_auth(account_id)
        end
      end

      describe 'query' do
        let(:body) { load_sample('appointment_statuses.response.json') }
        let(:response) { build_response(body: body) }
        let(:ep) { Updox::Models::Appointment::LIST_ENDPOINT }
        let(:n) { 3 }

        before do
          @query_response = appointment.class.query([appt_id], account_id: account_id)
        end

        it 'calls list api' do
          assert_equal(1, @query_response.items.size)
        end

        describe '#find' do
          it 'can find a single one' do
            assert_equal(appt_id, appointment.class.find(appt_id, account_id: account_id)[:externalAppointmentId])
          end

          it 'returns nil if none found' do
            assert_nil(appointment.class.find('cat', account_id: account_id))
          end

          it 'can use cache' do
            assert_requested(@stub, times: 1)
            n.times { appointment.class.find(appt_id, account_id: account_id, cached_query: @query_response) }
            assert_requested(@stub, times: 1)
          end

          it 'cache returns same result' do
            assert_equal(appointment.class.find(appt_id, account_id: account_id), appointment.class.find(appt_id, account_id: account_id, cached_query: @query_response))
          end
        end

        describe '#exists?' do
          it 'true if found' do
            assert(appointment.class.exists?(appt_id, account_id: account_id))
          end

          it 'false if none found' do
            assert_equal(false, appointment.class.exists?('cat', account_id: account_id))
          end

          it 'can use cache' do
            assert_requested(@stub, times: 1)
            n.times { appointment.class.exists?(appt_id, account_id: account_id, cached_query: @query_response) }
            assert_requested(@stub, times: 1)
          end

          it 'cache returns same result' do
            assert_equal(appointment.class.exists?(appt_id, account_id: account_id), appointment.class.exists?(appt_id, account_id: account_id, cached_query: @query_response))
          end
        end

        it 'has acct auth' do
          assert_acct_auth(account_id)
        end
      end
    end
  end
end
