require 'test_helper'

class PatientMessageTest < Minitest::Test
  describe 'patient message' do
    let(:pm) { Updox::Models::PatientMessage.new(internal_id: '123') }
    let(:account_id) { 'account_0001' }

    describe 'api' do
      before do
        stub_updox(endpoint: ep, response: response)

        WebMock.after_request do |request, response|
          @request = request
        end
      end

      describe 'query' do
        let(:response) { build_response(file: 'patient_message_count.response.json') }
        let(:ep) { Updox::Models::PatientMessage::LIST_ENDPOINT }

        before do
          pm.class.query('123', account_id: account_id)
        end

        it 'calls query api' do
          assert_equal('123', request_body['patientId'])
        end

        it '#exists?' do
          assert(pm.class.exists?('123', account_id: account_id))
        end

        it 'has acct auth' do
          assert_acct_auth(account_id)
        end
      end
    end
  end
end
