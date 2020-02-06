require 'test_helper'

class UpdoxTest < Minitest::Test
  PATIENT = {
      Identifiers: [],
      Demographics: {
        FirstName: 'Joe'
      }
  }.freeze

  describe 'redox' do
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

    {
      application_id: 'a',
      application_password: 'b',
      api_endpoint: 'http://hi.com',
      parse_responses: false
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
