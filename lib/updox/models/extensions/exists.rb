module Updox
  module Models
    module Extensions
      module Exists
        def exists?(item_id, account_id: , cached_query: nil)
          raise UpdoxException.new('Not implemented on this model.') unless self.respond_to?(:find)
          opts = { account_id: account_id }
          opts[:cached_query] = cached_query unless cached_query.nil?

          begin
            response = self.find(item_id, **opts)

            false == response.nil?
          rescue Updox::UpdoxException => e
            raise e unless :raise == Updox.configuration.failure_action && e.message.include?('does not exist')
            false
          end
        end
      end
    end
  end
end
