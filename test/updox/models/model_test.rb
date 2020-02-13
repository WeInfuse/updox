require 'test_helper'

module Updox
  module Models
    class FakeModel < Model
      LIST_TYPE = 'catList'
      LIST_NAME = 'cats'
      ITEM_TYPE = 'cat'

      property :meows, required: false
    end
  end
end

class ModelTest < Minitest::Test
  describe 'model' do
    describe '#from_response' do
      let(:auth) { Updox::Models::Auth.new }

      it 'adds item' do
        stub_updox()
        resp  = auth.ping
        model = Updox::Models::Model.from_response(resp)
        assert_equal(resp.parsed_response, model.item)
        assert_equal(resp.parsed_response, model.items.first)
      end

      it 'adds items' do
        stub_updox(response: build_response(body: ['a', 'b'].to_json))
        resp  = auth.ping
        model = Updox::Models::Model.from_response(resp)
        assert_nil(model.item)
        assert_equal(2, model.items.size)
      end

      it 'adds updox status info' do
        stub_updox(response: build_response(body: { responseCode: 3888, successful: false, responseMessage: 'Bad Model'}.to_json))
        resp  = auth.ping
        model = Updox::Models::Model.from_response(resp)
        assert_equal(false, model.successful?)
        assert_equal(3888, model.response_code)
        assert_equal('Bad Model', model.response_message)
      end

      it 'raises for bad response' do
        stub_updox(response: build_response(status: 404))
        resp  = auth.ping
        err   = assert_raises(Updox::UpdoxException) { Updox::Models::Model.from_response(resp) }
        assert_match(/404/, err.message)
      end

      describe 'conversions' do
        describe 'single item' do
          before do
            stub_updox(response: build_response(body: { cat: { meows: 10 } }.to_json))
            @model = Updox::Models::Model.from_response(auth.ping, Updox::Models::FakeModel)
          end

          it 'leaves items nil' do
            assert_nil(@model.items)
          end

          it 'creates and item of type' do
            assert(@model.item.is_a?(Updox::Models::FakeModel))
            assert_equal(10, @model.item.meows)
          end

          it 'gives an alias to the ITEM_TYPE' do
            assert_equal(@model.item, @model.cat)
          end
        end

        describe 'list of items' do
          before do
            stub_updox(response: build_response(body: { catList: [{meows: 5}, {meows: 9}] }.to_json))
            @model = Updox::Models::Model.from_response(auth.ping, Updox::Models::FakeModel)
          end

          it 'leaves item nil' do
            assert_nil(@model.item)
          end

          it 'creates a array' do
            assert_equal(2, @model.items.size)
          end

          it 'has items of the type in the array' do
            assert(@model.items.all? {|item| item.is_a?(Updox::Models::FakeModel) })
          end

          it 'gives an alias to the LIST_TYPE' do
            assert_equal(@model.items, @model.cats)
          end
        end
      end
    end
  end
end
