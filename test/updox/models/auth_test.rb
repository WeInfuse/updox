require 'test_helper'

class AuthTest < Minitest::Test
  describe 'auth' do
    let(:auth) { Updox::Models::Auth.new }
    let(:uid) { 'my_user_id' }
    let(:aid) { 'my_account_id' }

    describe 'object' do
      describe '#to_h' do
        it 'adds auth key' do
          assert({auth:{}}, auth.to_h)
        end
      end
    end

    describe 'endpoints' do
      before do
        stub_updox(endpoint: endpoint, response: build_response())
        auth.userId    = uid
        auth.accountId = aid

        WebMock.after_request do |request, response|
          @request = request
        end

        auth.send(auth_method)

        @request_auth = JSON.parse(@request.body).dig('auth')
      end

      describe 'ping' do
        let(:endpoint) { Updox::Models::Auth::PING_ENDPOINT }
        let(:auth_method) { :ping }

        it 'has no authorization' do
          assert(@request_auth.empty?)
        end
      end

      describe 'ping with app auth' do
        let(:endpoint) { Updox::Models::Auth::PING_APP_ENDPOINT }
        let(:auth_method) { :ping_with_application_auth }

        it 'has app authorization' do
          assert_equal(Updox.configuration.application_id, @request_auth.dig('applicationId'))
          assert_equal(Updox.configuration.application_password, @request_auth.dig('applicationPassword'))
          assert_nil(@request_auth.dig('accountId'))
          assert_nil(@request_auth.dig('userId'))
        end
      end

      describe 'ping with account auth' do
        let(:endpoint) { Updox::Models::Auth::PING_ACCT_ENDPOINT }
        let(:auth_method) { :ping_with_account_auth }

        it 'has account authorization' do
          assert_equal(Updox.configuration.application_id, @request_auth.dig('applicationId'))
          assert_equal(Updox.configuration.application_password, @request_auth.dig('applicationPassword'))
          assert_equal(aid, @request_auth.dig('accountId'))
          assert_nil(@request_auth.dig('userId'))
        end
      end

      describe 'ping with full auth' do
        let(:endpoint) { Updox::Models::Auth::PING_FULL_ENDPOINT }
        let(:auth_method) { :ping_with_full_auth }

        it 'has full authorization' do
          assert_equal(Updox.configuration.application_id, @request_auth.dig('applicationId'))
          assert_equal(Updox.configuration.application_password, @request_auth.dig('applicationPassword'))
          assert_equal(aid, @request_auth.dig('accountId'))
          assert_equal(uid, @request_auth.dig('userId'))
        end
      end
    end
  end
end
