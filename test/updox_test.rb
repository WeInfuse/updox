require 'test_helper'

class UpdoxTest < Minitest::Test
  PATIENT = {
      Identifiers: [],
      Demographics: {
        FirstName: 'Joe'
      }
  }.freeze

  describe 'updox' do
    it 'has a version' do
      assert(::Updox::VERSION)
    end
  end

  describe '#connection' do
    it 'returns a connection object' do
      assert(Updox::UpdoxClient.connection.is_a?(Updox::Connection))
    end
  end

  describe 'configuration' do
    before do
      @config = Updox.configuration.to_h
    end

    after do
      Updox.configuration.from_h(@config)
    end

    describe 'failure_action' do
      it 'allows :raise' do
        Updox.configuration.failure_action = :raise
      end

      it 'allows lambda' do
        Updox.configuration.failure_action = ->(x) { 10 }
      end

      it 'allows nil' do
        Updox.configuration.failure_action = nil
      end

      it 'disallows anything else' do
        err = assert_raises { Updox.configuration.failure_action = {h: 10} }
        assert_match(/Failure action must be 'nil', ':raise' or callable object!/, err.message)

        err = assert_raises { Updox.configuration.failure_action = :cat }
        assert_match(/Failure action must be 'nil', ':raise' or callable object!/, err.message)
      end
    end

    {
      application_id: 'a',
      application_password: 'b',
      api_endpoint: 'http://hi.com',
      parse_responses: false,
      failure_action: :raise
    }.each do |method, value|
      it "can set #{method} via configuration" do
        assert(Updox.configuration.respond_to?(method))
        Updox.configuration.send("#{method}=", value)

        assert_equal(value, Updox.configuration.send("#{method}"))
      end

      it "can set #{method} via configure block" do
        Updox.configure do |c|
          assert(c.respond_to?(method))
          c.send("#{method}=", value)

          assert_equal(value, Updox.configuration.send("#{method}"))
        end
      end
    end
  end
end
