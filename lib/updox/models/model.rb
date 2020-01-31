module Updox
  module Models
    DATETIME_FORMAT = '%Y-%m-%d %H:%M'.freeze

    class Model < Hashie::Trash
      include Hashie::Extensions::IgnoreUndeclared
      include Hashie::Extensions::IndifferentAccess

      LIST_TYPE = 'undefined'
      LIST_NAME = 'models'

      property :item, required: false
      property :items, required: false

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
          else
            model.items = [data]
            model.item  = data
          end
        else
          raise UpdoxException.from_response(response)
        end

        return model
      end
    end
  end
end
