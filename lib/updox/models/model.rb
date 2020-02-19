module Updox
  module Models
    DATETIME_FORMAT = '%Y-%m-%d %H:%M'.freeze
    DATETIME_OTHER_FORMAT = '%m/%d/%Y %H:%M:%s %z'.freeze

    RECOMMENDED_BATCH_SIZE = 200

    class Model < Hashie::Trash
      include Hashie::Extensions::IgnoreUndeclared
      include Hashie::Extensions::IndifferentAccess

      LIST_TYPE = 'undefined'
      LIST_NAME = 'models'
      ITEM_TYPE = 'model'

      property :item, required: false
      property :items, required: false
      property :updox_status, default: {}

      def successful?
        self[:updox_status].dig('successful')
      end

      def response_code
        self[:updox_status].dig('responseCode')
      end

      def response_message
        self[:updox_status].dig('responseMessage')
      end

      def error_message
        "#{response_code}: #{response_message}"
      end

      def self.exists?(item_id, account_id: , cached_query: nil)
        raise UpdoxException.new('Not implemented on this model.') unless self.respond_to?(:find)
        opts = { account_id: account_id }
        opts[:cached_query] = cached_query unless cached_query.nil?

        response = self.find(item_id, **opts)

        false == response.nil? && (false == self.const_defined?(:FIND_ENDPOINT) || response.successful?)
      end

      def self.sync(items, account_id: , batch_size: RECOMMENDED_BATCH_SIZE, endpoint: self.const_get(:SYNC_ENDPOINT))
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

      def self.request(**kwargs)
        from_response(UpdoxClient.connection.request(kwargs))
      end

      def self.from_response(response, klazz = self)
        return response if false == Updox.configuration.parse_responses?

        model = Model.new
        model.define_singleton_method(:response) { response }

        if (response.ok?)
          data = response.parsed_response

          if data.is_a?(Array)
            model.items = data
          elsif data&.include?(klazz.const_get(:LIST_TYPE))
            model.items = data.dig(klazz.const_get(:LIST_TYPE)).map { |obj| klazz.new(obj) }
            model.define_singleton_method(klazz.const_get(:LIST_NAME)) { self.items }
          elsif data&.include?(klazz.const_get(:ITEM_TYPE))
            model.item = klazz.new(data.dig(klazz.const_get(:ITEM_TYPE)))
            model.define_singleton_method(klazz.const_get(:ITEM_TYPE)) { self.item }
          else
            k = data&.keys&.find {|k| k.to_s.downcase.end_with?('statuses') }
            c = 'Updox::Models::' + k[0..-3].capitalize if k

            if k.nil? || false == Module.const_defined?(c)
              model.items = [data]
            else
              statuses = data.delete(k)

              model.items = statuses.map {|status| Object.const_get(c).new(status) }
              model.define_singleton_method(:statuses) { self.items }
            end

            model.item  = data
          end

          model.updox_status = data&.select {|k,v| ['successful', 'responseMessage', 'responseCode'].include?(k)} || {}
        else
          raise UpdoxException.from_response(response)
        end

        return model
      end
    end
  end
end
