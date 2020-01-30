require 'test_helper'

class PatientTest < Minitest::Test
  describe 'patient' do
    let(:patient) { Updox::Models::Patient.new(internal_id: '123') }
    let(:account_id) { 'account_0001' }

    describe 'object' do
      describe 'serializes' do
        it 'can serialize to json' do
          result = JSON.parse(patient.to_json)

          assert_equal(patient.internalId, result['internalId'])
        end
      end
    end

    describe 'sync' do
      before do
        stub_updox(endpoint: Updox::Models::Patient::SYNC_ENDPOINT, response: build_response())

        WebMock.after_request do |request, response|
          @request = request
        end

        patient.class.sync([patient], account_id: account_id)
      end

      it 'calls sync api' do
        request_body = JSON.parse(@request.body)

        assert_equal(request_body['patients'].first, patient.to_h)
      end

      it 'has acct auth' do
        assert_acct_auth(@request, account_id)
      end
    end
  end
end
