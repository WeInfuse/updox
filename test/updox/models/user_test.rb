require 'test_helper'

class UserTest < Minitest::Test
  describe 'user' do
    let(:user) { Updox::Models::User.new(first_name: 'Larry', last_name: 'Larryton') }
    let(:aid) { 'my_account_id' }

    describe 'object' do
      describe '#first_name' do
        it 'is required' do
          err = assert_raises { Updox::Models::User.new }
          assert_match(/is required/, err.message)
        end
      end

      describe 'serializes' do
        it 'can serialize to json' do
          result = JSON.parse(user.to_json)

          assert_equal(result['firstName'], user.first_name)
        end
      end

      it 'allows other methods' do
        user.user_id = 12345

        assert_equal(12345, user.user_id)
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
        let(:ep) { Updox::Models::User::SAVE_ENDPOINT }

        before do
          user.create(account_id: aid)
        end

        it 'calls create api' do
          assert_equal(request_body['firstName'], user.first_name)
        end

        it 'has account auth' do
          assert_acct_auth(aid)
        end
      end

      describe 'query' do
        let(:body) { load_sample('user_list.response.json') }
        let(:response) { build_response(body: body) }
        let(:ep) { Updox::Models::User::QUERY_ENDPOINT }

        before do
          @response = user.class.query
        end

        it 'gets response' do
          assert_equal(1, @response.items.size)
          assert_equal('Larry', @response.items.first.first_name)
        end

        it 'has app auth' do
          assert_app_auth()
        end
      end

      describe 'find' do
        let(:body) { load_sample('user_find.response.json') }
        let(:response) { build_response(body: body) }
        let(:ep) { Updox::Models::User::FIND_ENDPOINT }

        before do
          @response = user.class.find('my_user_id', account_id: aid)
        end

        it 'gets response' do
          assert_equal('Larry', @response.user.first_name)
        end

        it 'has app auth' do
          assert_acct_auth(aid)
        end

        describe '#exists?' do
          it 'calls find' do
            user.class.exists?('my_user_id', account_id: aid)
          end
        end
      end
    end
  end
end
