require 'test_helper'

class StatusTest < Minitest::Test
  describe 'appointment status' do
    let(:klazz) { Updox::Models::Status }
    let(:response) { load_sample('error.sync.response.json', parse: true) }

  end
end
