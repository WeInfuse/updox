require 'test_helper'

class PracticeTest < Minitest::Test
  describe 'practice' do
    let(:practice) { Updox::Models::Practice.new(name: 'Catcity LLC') }

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
        practice.account_id = 12345

        assert_equal('12345', practice.account_id)
      end
    end

    describe 'create' do
      before do
        stub_updox(endpoint: Updox::Models::Practice::CREATE_ENDPOINT, response: build_response())

        WebMock.after_request do |request, response|
          @request = request
        end

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
      before do
        stub_updox(endpoint: Updox::Models::Practice::QUERY_ENDPOINT, response: build_response(body: [1, 2].to_json))

        WebMock.after_request do |request, response|
          @request = request
        end

        @response = practice.class.query
      end

      it 'gets response' do
        assert_equal(2, @response.parsed_response.size)
      end

      it 'has app auth' do
        assert_app_auth(@request)
      end
    end
  end
end
