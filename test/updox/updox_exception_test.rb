require 'test_helper'

class UpdoxExceptionTest < Minitest::Test
  describe 'updox exception' do
    let(:error) { load_sample('error.response.json') }
    let(:auth) { Updox::Models::Auth.new }

    it 'can parse a response' do
      stub_updox(response: build_response(body: error))
      resp  = auth.ping
      exception = Updox::UpdoxException.new(resp)
      assert_match(/Bad Request/, exception.message)
    end
  end
end
