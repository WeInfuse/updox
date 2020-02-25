require 'test_helper'

class ExistsTest < Minitest::Test
  class FakeModelNoFind < Updox::Models::Model
    extend Updox::Models::Extensions::Exists
  end

  class FakeModel < FakeModelNoFind
    def self.find(id, account_id: , cached_query: nil)
      cached_query
    end
  end

  class FakeModelRaises < FakeModelNoFind
    def self.find(id, account_id: , cached_query: )
      raise Updox::UpdoxException.new(cached_query)
    end
  end

  describe 'exists' do
    let(:fake) { FakeModel.new }
    let(:account_id) { '123' }

    describe 'find method missing' do
      it 'raises if find method not implemented' do
        err = assert_raises(Updox::UpdoxException) { FakeModelNoFind.exists?(1, account_id: account_id) }
        assert_match(/Not implemented on this model/, err.message)
      end
    end

    describe 'find method found' do
      it 'interprets nil response as false' do
        assert_equal(false, fake.class.exists?(1, account_id: account_id))
      end

      it 'interprets anything else as true' do
        assert(fake.class.exists?(1, account_id: account_id, cached_query: {}))
      end

      describe 'exceptions' do
        let(:fake) { FakeModelRaises }

        it 'allows exceptions through' do
          err = assert_raises(Updox::UpdoxException) { fake.exists?(1, account_id: account_id, cached_query: 'cat does not exist') }
          assert_match(/cat does not exist/, err.message)
        end

        describe 'if config is set to :raise' do
          before do
            @config = Updox.configuration.to_h
            Updox.configuration.failure_action = :raise
          end

          after do
            Updox.configuration.from_h(@config)
          end

          it 'returns false if does not exist' do
            assert_equal(false, fake.exists?(1, account_id: account_id, cached_query: 'cat does not exist'))
          end

          it 'raises if other type of error' do
            err = assert_raises(Updox::UpdoxException) { fake.exists?(1, account_id: account_id, cached_query: 'cat is unauthorized') }
            assert_match(/cat is unauthorized/, err.message)
          end
        end
      end
    end
  end
end
