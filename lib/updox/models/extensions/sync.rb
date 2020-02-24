module Updox
  module Models
    module Extensions
      module Sync
        RECOMMENDED_BATCH_SIZE = 200

        def sync(items, account_id: , batch_size: RECOMMENDED_BATCH_SIZE, endpoint: self.const_get(:SYNC_ENDPOINT))
          response  = nil
          list_type = self.const_get(:SYNC_LIST_TYPE)

          if 0 >= batch_size
            response = request(endpoint: endpoint, body: { list_type => items }, auth: {accountId: account_id}, required_auths: Updox::Models::Auth::AUTH_ACCT)
          else
            items.each_slice(batch_size) do |batch|
              r = request(endpoint: endpoint, body: { list_type => batch }, auth: {accountId: account_id}, required_auths: Updox::Models::Auth::AUTH_ACCT)

              return r unless r.successful?

              if response
                response.items += r.items
              else
                response = r
              end
            end
          end

          return response
        end
      end
    end
  end
end
