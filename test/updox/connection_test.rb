require 'test_helper'

class ConnectionTest < Minitest::Test
  describe 'connection' do
    let(:auth) { Updox::Models::Auth.new }
    let(:connection) { Updox::Connection.new }
    let(:auth_data) { -> { JSON.parse(@request.body).dig('auth') } }

    before do
      stub_updox

      WebMock.after_request do |request, response|
        @request = request
      end
    end

    describe 'auth option' do
      describe 'default' do
        before do
          connection.request
        end

        it 'default omits auth data' do
          assert_requested(@stub, times: 1)
        end

        it 'includes blank auth json' do
          assert(auth_data.call.empty?)
        end
      end

      describe 'with auth object' do
        before do
          auth.accountId = :dog
          auth.userId    = :cat
        end

        it 'defaults to no required auths' do
          connection.request(auth: auth)

          assert_requested(@stub, times: 1)

          assert(auth_data.call.empty?)
        end

        it 'adds application auth if required' do
          connection.request(auth: auth, required_auths: Updox::Models::Auth::AUTH_APP)

          assert_requested(@stub, times: 1)

          assert(false == auth_data.call.empty?)

          assert_equal(Updox.configuration.application_id, auth_data.call.dig('applicationId'))
          assert_equal(Updox.configuration.application_password, auth_data.call.dig('applicationPassword'))
          assert_nil(auth_data.call.dig('accountId'))
          assert_nil(auth_data.call.dig('userId'))
        end

        it 'leaves application auth if included' do
          auth.applicationId = 'blahblah'

          connection.request(auth: auth, required_auths: Updox::Models::Auth::AUTH_APP)

          assert_requested(@stub, times: 1)

          assert(false == auth_data.call.empty?)

          assert_equal('blahblah', auth_data.call.dig('applicationId'))
          assert_equal(Updox.configuration.application_password, auth_data.call.dig('applicationPassword'))
          assert_nil(auth_data.call.dig('accountId'))
          assert_nil(auth_data.call.dig('userId'))
        end
      end
    end

    it 'returns response' do
      response = connection.request

      assert(response.ok?)
      assert_equal({}, response.parsed_response)
      assert_equal('{}', response.body)
    end

    it 'changes body to json for hashes' do
      connection.request(body: {h: 10})

      assert_requested(@stub, times: 1)
      assert_equal(auth.to_h.merge({h:10}).to_json, @request.body)
    end

    it 'uses exact body when not a hash' do
      connection.request(body: 'hi')

      assert_requested(@stub, times: 1)
      assert_equal('hi', @request.body)
    end

    it 'passes headers' do
      connection.request(headers: {'x' => '10'})

      assert_requested(@stub, times: 1)
      assert_equal('10', @request.headers['X'])
    end
  end
end
