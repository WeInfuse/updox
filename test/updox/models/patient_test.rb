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

    describe 'api' do
      before do
        stub_updox(endpoint: ep, response: response)

        WebMock.after_request do |request, response|
          @request = request
        end
      end

      describe 'sync' do
        let(:response) { nil }
        let(:ep) { Updox::Models::Patient::SYNC_ENDPOINT }

        before do
          patient.save(account_id: account_id)
        end

        it 'calls sync api' do
          assert_equal(1, request_body['patients'].size)
          assert_equal(patient.to_h, request_body['patients'].first)
        end

        it 'has bulk call' do
          patient.class.sync([patient, patient], account_id: account_id)

          assert_equal(2, request_body['patients'].size)
          assert_equal(patient.to_h, request_body['patients'].first)
        end

        it 'has acct auth' do
          assert_acct_auth(account_id)
        end
      end

      describe '#exists?' do
        let(:response) { nil }
        let(:ep) { Updox::Models::PatientMessage::LIST_ENDPOINT }

        it 'calls patient message' do
          assert(patient.class.exists?(1, account_id: account_id))
        end
      end
    end
  end
end
