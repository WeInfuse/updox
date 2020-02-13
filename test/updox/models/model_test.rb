require 'test_helper'

module Updox
  module Models
    class FakeModel < Model
      FAKE_ENDPOINT = '/CatsMeow'

      LIST_TYPE = 'catList'
      LIST_NAME = 'cats'
      ITEM_TYPE = 'cat'

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
