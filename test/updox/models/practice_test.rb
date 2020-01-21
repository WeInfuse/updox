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
      end

      it 'calls create api' do
        practice.create
        request_body = JSON.parse(@request.body)

        assert_equal(request_body['name'], practice.name)
      end
    end
  end
end
