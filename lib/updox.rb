require 'httparty'
require 'hashie'
require 'updox/version'
require 'updox/updox_exception'
require 'updox/connection'
require 'updox/models/model'
require 'updox/models/auth'
require 'updox/models/application'
require 'updox/models/appointment'
require 'updox/models/appointment_status'
require 'updox/models/calendar'
require 'updox/models/location'
require 'updox/models/patient'
require 'updox/models/practice'
require 'updox/models/reminder'
require 'updox/models/status'
require 'updox/models/user'

module Updox
  class Configuration
    attr_accessor :application_id, :application_password, :parse_responses
    attr_reader :failure_action

    alias_method :parse_responses?, :parse_responses

    def initialize
      @application_id       = nil
      @application_password = nil
      @parse_responses      = true
      @failure_action       = nil
    end

    def failure_action=(value)
      raise "Failure action must be 'nil', ':raise' or callable object!" unless value.nil? || value.respond_to?(:call) || :raise == value
      @failure_action = value
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
        api_endpoint: api_endpoint,
        parse_responses: @parse_responses,
        failure_action: @failure_action
      }
    end

    def from_h(h)
      self.application_id = h[:application_id]
      self.application_password  = h[:application_password]
      self.api_endpoint = h[:api_endpoint]
      self.parse_responses = h[:parse_responses]
      self.failure_action = h[:failure_action]

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
