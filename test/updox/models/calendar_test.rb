require 'test_helper'

class CalendarTest < Minitest::Test
  describe 'calendar' do
    let(:calendar) { Updox::Models::Calendar.new(id: '1', title: 'Calendar 1') }
    let(:account_id) { 'account_0001' }
    let(:cid) { 'C1' }

    describe 'object' do
      describe 'serializes' do
        it 'can serialize to json' do
          result = JSON.parse(calendar.to_json)

          assert_equal(result['title'], calendar.title)
        end
      end
    end

    describe 'api' do
      before do
        stub_updox(endpoint: ep, response: response)

        WebMock.after_request do |request, response|
          @request = request
        end
      end

      describe 'create' do
        let(:response) { nil }
        let(:ep) { Updox::Models::Calendar::SYNC_ENDPOINT }

        before do
          calendar.create(account_id: account_id)
        end

        it 'calls create api' do
          assert_equal(request_body['title'], calendar.title)
        end

        it 'has acct auth' do
          assert_acct_auth(account_id)
        end
      end

      describe 'query' do
        let(:body) { load_sample('calendars_list.response.json') }
        let(:response) { build_response(body: body) }
        let(:ep) { Updox::Models::Calendar::LIST_ENDPOINT }
        let(:n) { 3 }

        before do
          @query_response = calendar.class.query(account_id: account_id)
        end

        it 'calls list api' do
          assert_equal(1, @query_response.calendars.size)
        end

        describe '#find' do
          it 'can find a single one' do
            assert_equal('My Calendar', calendar.class.find(cid, account_id: account_id).title)
          end

          it 'returns nil if none found' do
            assert_nil(calendar.class.find('cat', account_id: account_id))
          end

          it 'can use cache' do
            assert_requested(@stub, times: 1)
            n.times { calendar.class.find(cid, account_id: account_id, cached_query: @query_response) }
            assert_requested(@stub, times: 1)
          end

          it 'cache returns same result' do
            assert_equal(calendar.class.find(cid, account_id: account_id), calendar.class.find(cid, account_id: account_id, cached_query: @query_response))
          end
        end

        describe '#exists?' do
          it 'true if found' do
            assert(calendar.class.exists?(cid, account_id: account_id))
          end

          it 'false if none found' do
            assert_equal(false, calendar.class.exists?('cat', account_id: account_id))
          end

          it 'can use cache' do
            assert_requested(@stub, times: 1)
            n.times { calendar.class.exists?(cid, account_id: account_id, cached_query: @query_response) }
            assert_requested(@stub, times: 1)
          end

          it 'cache returns same result' do
            assert_equal(calendar.class.exists?(cid, account_id: account_id), calendar.class.exists?(cid, account_id: account_id, cached_query: @query_response))
          end
        end

        it 'has acct auth' do
          assert_acct_auth(account_id)
        end
      end
    end
  end
end
