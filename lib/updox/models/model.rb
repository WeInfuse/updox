module Updox
  module Models
    DATETIME_FORMAT = '%Y-%m-%d %H:%M'.freeze

    #BATCH_SIZE = 200

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
            model.items = [data]
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
