require 'test_helper'

class AppointmentStatusTest < Minitest::Test
  describe 'appointment status' do
    let(:klazz) { Updox::Models::AppointmentStatus }
    let(:account_id) { 'account_0001' }
    let(:appt_id) { '123' }

    describe 'api' do
      before do
        stub_updox(endpoint: ep, response: response)

        WebMock.after_request do |request|
          @request = request
        end
      end

      describe 'query' do
        let(:body) { load_sample('appointment_statuses.response.json') }
        let(:response) { build_response(body: body) }
        let(:ep) { Updox::Models::AppointmentStatus::LIST_ENDPOINT }
        let(:n) { 3 }

        before do
          @query_response = klazz.query([appt_id], account_id: account_id)
        end

        it 'calls list api' do
          assert_equal(1, @query_response.items.size)
        end

        it 'serializes reminder correctly' do
          assert_equal(2, @query_response.items.first.reminders.size)
          assert_kind_of(Updox::Models::Reminder, @query_response.items.first.reminders.first)
        end

        describe '#find' do
          it 'can find a single one' do
            assert_equal(appt_id, klazz.find(appt_id, account_id: account_id).external_appointment_id)
          end

          it 'returns nil if none found' do
            assert_nil(klazz.find('cat', account_id: account_id))
          end

          it 'can use cache' do
            assert_requested(@stub, times: 1)
            n.times { klazz.find(appt_id, account_id: account_id, cached_query: @query_response) }
            assert_requested(@stub, times: 1)
          end

          it 'cache returns same result' do
            assert_equal(klazz.find(appt_id, account_id: account_id), klazz.find(appt_id, account_id: account_id, cached_query: @query_response))
          end
        end

        describe '#exists?' do
          it 'true if found' do
            assert(klazz.exists?(appt_id, account_id: account_id))
          end

          it 'false if none found' do
            assert_equal(false, klazz.exists?('cat', account_id: account_id))
          end

          it 'can use cache' do
            assert_requested(@stub, times: 1)
            n.times { klazz.exists?(appt_id, account_id: account_id, cached_query: @query_response) }
            assert_requested(@stub, times: 1)
          end

          it 'cache returns same result' do
            assert_equal(klazz.exists?(appt_id, account_id: account_id), klazz.exists?(appt_id, account_id: account_id, cached_query: @query_response))
          end
        end

        it 'has acct auth' do
          assert_acct_auth(account_id)
        end
      end
    end
  end
end
