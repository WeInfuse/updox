require 'httparty'
require 'hashie'
require 'updox/version'
require 'updox/updox_exception'
require 'updox/connection'
require 'updox/models/model'
require 'updox/models/auth'
require 'updox/models/appointment'
require 'updox/models/calendar'
require 'updox/models/location'
require 'updox/models/patient'
require 'updox/models/practice'

module Updox
  class Configuration
    attr_accessor :application_id, :application_password

    def initialize
      @application_id       = nil
      @application_password = nil
    end

    def api_endpoint=(endpoint)
      Connection.base_uri(endpoint.freeze)
    end

    def api_endpoint
      return Connection.base_uri
    end

    def to_h
      return {
        application_id: @application_id,
        application_password: @application_password,
        api_endpoint: api_endpoint
      }
    end

    def from_h(h)
      self.application_id = h[:application_id]
      self.application_password  = h[:application_password]
      self.api_endpoint = h[:api_endpoint]

      return self
    end
  end

  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end
  end

  # Updox API client
  class UpdoxClient
    class << self
      def connection
        @connection ||= Connection.new
      end

      def release
        @connection = nil
      end
    end
  end
end
