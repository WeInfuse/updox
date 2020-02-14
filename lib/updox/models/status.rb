module Updox
  module Models
    class Status < Model
      LIST_TYPE = 'statuses'
      LIST_NAME = LIST_TYPE

      property :id
      property :success
      property :message

      alias_method :success?, :success
    end
  end
end
