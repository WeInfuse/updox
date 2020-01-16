require 'test_helper'

class ConnectionTest < Minitest::Test
  describe 'connection' do
    let(:auth) { Updox::Models::Auth.build_auth }

    before do
      stub_updox

      @connection = Updox::Connection.new

      WebMock.after_request do |request, response|
        @request = request
      end
    end

    describe 'auth option' do
      it 'false omits auth data' do
        @connection.request(auth: false)

        assert_requested(@stub, times: 1)
      end

      it 'includes blank auth json' do
        @connection.request(auth: false)

        data = JSON.parse(@request.body)

        assert_equal('', data.dig('auth', 'applicationId'))
        assert_equal('', data.dig('auth', 'applicationPassword'))
      end
    end

    it 'returns response' do
      response = @connection.request()

      assert(response.ok?)
      assert_equal({}, response.parsed_response)
      assert_equal('{}', response.body)
    end

    it 'changes body to json for hashes' do
      @connection.request(auth: false, body: {h: 10})

      assert_requested(@stub, times: 1)
      assert_equal(auth.merge({h:10}).to_json, @request.body)
    end

    it 'changes body to json for hashes' do
      @connection.request(auth: false, body: 'hi')

      assert_requested(@stub, times: 1)
      assert_equal('hi', @request.body)
    end

    it 'passes headers' do
      @connection.request(headers: {'x' => '10'})

      assert_requested(@stub, times: 1)
      assert_equal('10', @request.headers['X'])
    end
  end
end
