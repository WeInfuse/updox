require 'test_helper'

class CalendarTest < Minitest::Test
  describe 'calendar' do
    let(:calendar) { Updox::Models::Calendar.new(id: '1', title: 'Calendar 1') }
    let(:account_id) { 'account_0001' }

    describe 'object' do
      describe 'serializes' do
        it 'can serialize to json' do
          result = JSON.parse(calendar.to_json)

          assert_equal(result['title'], calendar.title)
        end
      end
    end

    describe 'create' do
      before do
        stub_updox(endpoint: Updox::Models::Calendar::SYNC_ENDPOINT, response: build_response())

        WebMock.after_request do |request, response|
          @request = request
        end

        calendar.create(account_id: account_id)
      end

      it 'calls create api' do
        request_body = JSON.parse(@request.body)

        assert_equal(request_body['title'], calendar.title)
      end

      it 'has acct auth' do
        assert_acct_auth(@request, account_id)
      end
    end
  end
end
