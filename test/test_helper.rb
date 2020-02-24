$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'updox'

require 'minitest/autorun'
require 'webmock/minitest'
require 'byebug'

Updox.configuration.application_id = '123'
Updox.configuration.application_password  = 'abc'

class FakeResponse
  attr_accessor :body, :ok

  alias_method :ok?, :ok

  def initialize(body: {}.to_json, ok: true)
    @body = body
    @ok   = ok
  end

  def parsed_response
    return JSON.parse(body)
  end
end

class Minitest::Test
  def request_body(request = @request)
    JSON.parse(request.body)
  end

  def assert_app_auth(request: nil)
    @request ||= request
    assert_equal(Updox.configuration.application_id, request_body.dig('auth', 'applicationId'))
    assert_equal(Updox.configuration.application_password, request_body.dig('auth', 'applicationPassword'))
  end

  def assert_acct_auth(expected_account_id, request: nil)
    @request ||= request

    assert_app_auth()

    assert_equal(expected_account_id, request_body.dig('auth', 'accountId'))
  end

  def load_sample(file, parse: false)
    file = File.join('test', 'samples', file)
    file_contents = nil

    if (false == File.exist?(file))
      raise "Can't find file '#{file}'."
    end

    file_contents = File.read(file)

    if (true == parse)
      if (true == file.end_with?('.json'))
        return JSON.parse(file_contents)
      end
    end

    return file_contents
  end

  def build_response(status: nil, body: nil, headers: nil, file: nil)
    response = {}

    if status.nil?
      response[:status] = 200
    elsif status.is_a?(Symbol)
      response[:status] = Rack::Utils::SYMBOL_TO_STATUS_CODE[status]
    else
      response[:status] = status
    end

    response[:headers] = headers if (headers.is_a?(Hash))

    if (true == body.is_a?(Hash))
      body = body.to_json
    elsif (false == file.nil?)
      body = load_sample(file)
    end

    response[:body] = body if (false == body.nil?)
    response[:body] ||= load_sample('success.response.json') if 200 == response[:status]

    return response
  end

  def stub_updox_request(endpoint)
    return stub_request(:post, "#{Updox::Connection.base_uri}#{endpoint}")
  end

  def stub_updox(endpoint: Updox::Models::Auth::PING_ENDPOINT, response: nil)
    response ||= build_response(body: load_sample('success.response.json'))

    @stub = stub_updox_request(endpoint).to_return(response)
  end
end
