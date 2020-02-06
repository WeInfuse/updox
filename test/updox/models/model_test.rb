require 'test_helper'

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

      it 'raises for bad response' do
        stub_updox(response: build_response(status: 404))
        resp  = auth.ping
        err   = assert_raises(Updox::UpdoxException) { Updox::Models::Model.from_response(resp) }
        assert_match(/404/, err.message)
      end
    end
  end
end
