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
    end
  end
end
