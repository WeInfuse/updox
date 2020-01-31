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

    describe 'sync' do
      before do
        stub_updox(endpoint: Updox::Models::Location::SYNC_ENDPOINT, response: build_response())

        WebMock.after_request do |request, response|
          @request = request
        end

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
  end
end
