require 'test_helper'

class PracticeTest < Minitest::Test
  describe 'practice' do
    let(:practice) { Updox::Models::Practice.new(name: 'Catcity LLC') }
    let(:account_id) { 12345 }

    describe 'object' do
      describe '#name' do
        it 'is required' do
          err = assert_raises { Updox::Models::Practice.new }
          assert_match(/is required/, err.message)
        end
      end

      describe 'serializes' do
        it 'can serialize to json' do
          result = JSON.parse(practice.to_json)

          assert_equal(result['name'], practice.name)
        end
      end

      it 'allows other methods' do
        practice.account_id = account_id

        assert_equal(account_id.to_s, practice.account_id)
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
        let(:ep) { Updox::Models::Practice::CREATE_ENDPOINT }

        before do
          practice.create
        end

        it 'calls create api' do
          request_body = JSON.parse(@request.body)

          assert_equal(request_body['name'], practice.name)
        end

        it 'has app auth' do
          assert_app_auth(@request)
        end
      end

      describe 'query' do
        let(:body) { load_sample('practice_list.response.json') }
        let(:response) { build_response(body: body) }
        let(:ep) { Updox::Models::Practice::QUERY_ENDPOINT }

        before do
          @response = practice.class.query
        end

        it 'gets response' do
          assert_equal(1, @response.items.size)
          assert_equal('Acccounttown Inc', @response.items.first.name)
        end

        it 'has app auth' do
          assert_app_auth(@request)
        end
      end

      describe 'find' do
        let(:body) { load_sample('practice_find.response.json') }
        let(:response) { build_response(body: body) }
        let(:ep) { Updox::Models::Practice::FIND_ENDPOINT }

        before do
          @response = practice.class.find(account_id)
        end

        it 'gets response' do
          assert_equal('Acccounttown Inc', @response.item.name)
          assert_equal(@response.item.name, @response.practice.name)
        end

        it 'has app auth' do
          assert_app_auth(@request)
        end
      end
    end
  end
end
