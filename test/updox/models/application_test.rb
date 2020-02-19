require 'test_helper'

class ApplicationTest < Minitest::Test
  describe 'application' do
    let(:application) { Updox::Models::Application.new }

    describe 'object' do
      describe '#to_h' do
        it 'adds application key' do
          assert({application:{}}, application.to_h)
        end
      end
    end

    describe 'endpoints' do
      before do
        stub_updox(endpoint: endpoint, response: build_response(file: 'application_open.response.json'))

        WebMock.after_request do |request, response|
          @request = request
        end

        application.open(account_id: 'my_account_id', user_id: 'my_user_id')

        @request_auth = JSON.parse(@request.body).dig('auth')
      end

      describe 'open with full authorization' do
        let(:endpoint) { Updox::Models::Application::OPEN_ENDPOINT }

        it 'has full authorization' do
          assert_equal(Updox.configuration.application_id, @request_auth.dig('applicationId'))
          assert_equal(Updox.configuration.application_password, @request_auth.dig('applicationPassword'))
          assert_equal('my_account_id', @request_auth.dig('accountId'))
          assert_equal('my_user_id', @request_auth.dig('userId'))
        end

        it 'can provide a sso url' do
          assert_equal('https://updoxqa.com/sso/applicationOpen/123/abcdefabcdefabcdefabcdef1231231231231231', application.url(account_id: 'my_account_id', user_id: 'my_user_id'))
        end

        it 'can provide a sso url with overridden base uri' do
          assert_equal('cat/sso/applicationOpen/123/abcdefabcdefabcdefabcdef1231231231231231', application.url(account_id: 'my_account_id', user_id: 'my_user_id', base_uri: 'cat'))
        end
      end
    end
  end
end
