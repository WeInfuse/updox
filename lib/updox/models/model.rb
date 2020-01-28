module Updox
  module Models
    class Model < Hashie::Trash
      property :item, required: false
      property :items, required: false

      def self.from_response(response)
        model = Model.new

        if (response.ok?)
          data = response.parsed_response

          if data.is_a?(Array)
            model.items = data
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
