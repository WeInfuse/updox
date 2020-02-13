require 'test_helper'

class LocationTest < Minitest::Test
  describe 'location' do
    let(:loc) { Updox::Models::Location.new }
    let(:account_id) { 'account_0001' }

    describe 'object' do
      describe 'serializes' do
        it 'can serialize to json' do
          result = JSON.parse(loc.to_json)

          assert_equal(loc.active, result['active'])
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

      describe 'sync' do
        let(:response) { build_response() }
        let(:ep) { Updox::Models::Location::SYNC_ENDPOINT }

        before do
          loc.save(account_id: account_id)
        end

        it 'calls sync api' do
          request_body = JSON.parse(@request.body)

          assert_equal(1, request_body['locations'].size)
          assert_equal(loc.to_h, request_body['locations'].first)
        end

        it 'has bulk call' do
          loc.class.sync([loc, loc], account_id: account_id)

          request_body = JSON.parse(@request.body)

          assert_equal(2, request_body['locations'].size)
          assert_equal(loc.to_h, request_body['locations'].first)
        end

        it 'has acct auth' do
          assert_acct_auth(@request, account_id)
        end
      end

      describe 'query' do
        let(:body) { load_sample('locations_list.response.json') }
        let(:response) { build_response(body: body) }
        let(:ep) { Updox::Models::Location::LIST_ENDPOINT }
        let(:n) { 3 }

        before do
          @query_response = loc.class.query(account_id: account_id)
        end

        it 'calls list api' do
          assert_equal(2, @query_response.locations.size)
        end

        describe '#find' do
          it 'can find a single one' do
            assert_equal('Bobtown Pharmacy', loc.class.find(27, account_id: account_id).name)
          end

          it 'returns nil if none found' do
            assert_nil(loc.class.find('cat', account_id: account_id))
          end

          it 'can use cache' do
            assert_requested(@stub, times: 1)
            n.times { loc.class.find(27, account_id: account_id, cached_query: @query_response) }
            assert_requested(@stub, times: 1)
          end

          it 'cache returns same result' do
            assert_equal(loc.class.find(27, account_id: account_id), loc.class.find(27, account_id: account_id, cached_query: @query_response))
          end
        end

        describe '#exists?' do
          it 'true if found' do
            assert(loc.class.exists?(27, account_id: account_id))
          end

          it 'false if none found' do
            assert_equal(false, loc.class.exists?('cat', account_id: account_id))
          end

          it 'can use cache' do
            assert_requested(@stub, times: 1)
            n.times { loc.class.exists?(27, account_id: account_id, cached_query: @query_response) }
            assert_requested(@stub, times: 1)
          end

          it 'cache returns same result' do
            assert_equal(loc.class.exists?(27, account_id: account_id), loc.class.exists?(27, account_id: account_id, cached_query: @query_response))
          end
        end

        it 'has acct auth' do
          assert_acct_auth(@request, account_id)
        end
      end
    end
  end
end
