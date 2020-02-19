require 'test_helper'

module Updox
  module Models
    class FakeModel < Model
      FAKE_ENDPOINT = '/CatsMeow'
      SYNC_ENDPOINT = '/CatsSync'

      LIST_TYPE = 'catList'
      LIST_NAME = 'cats'
      ITEM_TYPE = 'cat'
      SYNC_LIST_TYPE = LIST_NAME

      property :meows, required: false

      def call!
        self.class.request
      end
    end
  end
end

class ModelTest < Minitest::Test
  describe 'model' do
    describe '#from_response' do
      let(:fake) { Updox::Models::FakeModel.new }
      let(:model) { fake.call! }
      let(:success) { load_sample('success.response.json', parse: true) }
      let(:account_id) { '123' }

      it 'adds item' do
        stub_updox()
        assert_equal(success, model.item)
        assert_equal(success, model.items.first)
      end

      it 'adds items' do
        stub_updox(response: build_response(body: ['a', 'b'].to_json))
        assert_nil(model.item)
        assert_equal(2, model.items.size)
      end

      it 'adds updox status info' do
        stub_updox(response: build_response(body: { responseCode: 3888, successful: false, responseMessage: 'Bad Model'}.to_json))
        assert_equal(false, model.successful?)
        assert_equal(3888, model.response_code)
        assert_equal('Bad Model', model.response_message)
        assert_equal('3888: Bad Model', model.error_message)
      end

      it 'raises for bad response' do
        stub_updox(response: build_response(status: 404))
        err   = assert_raises(Updox::UpdoxException) { fake.call! }
        assert_match(/404/, err.message)
      end

      describe 'batching' do
        let(:statuses_data) { (Updox::Models::RECOMMENDED_BATCH_SIZE + 1).times.map {|t| { id: t, success: true, message: 'blah blah' } } }
        let(:request_data) { { successful: true, responseMesssage: 'OK', responseCode: 2000 } }
        let(:effective_batch_size) { Updox::Models::RECOMMENDED_BATCH_SIZE }

        before do
          responses = []

          statuses_data.each_slice(effective_batch_size) {|data| responses << build_response(body: request_data.merge(statuses: data).to_json) }

          stub_updox(response: ->(request) { responses.shift }, endpoint: Updox::Models::FakeModel::SYNC_ENDPOINT)
        end

        describe 'batch size <= 0' do
          let(:effective_batch_size) { 99999 }

          it 'sends one request' do
            fake.class.sync(statuses_data.size.times.to_a, account_id: account_id, batch_size: 0)

            assert_requested(@stub, times: 1)
          end
        end

        describe 'batchs size > 0' do
          let(:effective_batch_size) { 50 }

          it 'batches things' do
            fake.class.sync(statuses_data.size.times.to_a, account_id: account_id, batch_size: effective_batch_size)

            assert_requested(@stub, times: (statuses_data.size.to_f / effective_batch_size).ceil)
          end
        end

        describe 'default batch' do
          before do
            @response = fake.class.sync(statuses_data.size.times.to_a, account_id: account_id)
          end

          it 'batches things' do
            assert_requested(@stub, times: 2)
          end

          it 'combines status responses' do
            assert_equal(statuses_data.size, @response.items.size)
          end

          it 'adds statuses alias' do
            assert_equal(@response.statuses.size, @response.items.size)
          end
        end
      end

      describe 'exists?' do
        it 'raises if find method not implemented' do
          err = assert_raises(Updox::UpdoxException) { fake.class.exists?(1, account_id: account_id) }
          assert_match(/Not implemented on this model/, err.message)
        end
      end

      describe 'conversions' do
        describe 'single item' do
          before do
            stub_updox(response: build_response(body: { cat: { meows: 10 } }.to_json))
          end

          it 'leaves items nil' do
            assert_nil(model.items)
          end

          it 'creates and item of type' do
            assert(model.item.is_a?(Updox::Models::FakeModel))
            assert_equal(10, model.item.meows)
          end

          it 'gives an alias to the ITEM_TYPE' do
            assert_equal(model.item, model.cat)
          end
        end

        describe 'statuses' do
          it 'converts into objects' do
            data = load_sample('error.sync.response.json', parse: true)

            stub_updox(response: build_response(body: data))

            assert_equal(data.reject {|k,v| k == 'statuses' }, model.item)
            assert_equal(2, model.items.size)
            assert_kind_of(Updox::Models::Status, model.items.first)
          end
        end

        describe 'list of items' do
          before do
            stub_updox(response: build_response(body: { catList: [{meows: 5}, {meows: 9}] }.to_json))
          end

          it 'leaves item nil' do
            assert_nil(model.item)
          end

          it 'creates a array' do
            assert_equal(2, model.items.size)
          end

          it 'has items of the type in the array' do
            assert(model.items.all? {|item| item.is_a?(Updox::Models::FakeModel) })
          end

          it 'gives an alias to the LIST_TYPE' do
            assert_equal(model.items, model.cats)
          end
        end
      end
    end
  end
end
