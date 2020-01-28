$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'updox'

require 'minitest/autorun'
require 'webmock/minitest'
require 'byebug'

Updox.configuration.application_id = '123'
Updox.configuration.application_password  = 'abc'

class Minitest::Test
  def assert_app_auth(request)
    request_body = JSON.parse(request.body)

    assert_equal(request_body.dig('auth', 'applicationId'), Updox.configuration.application_id)
    assert_equal(request_body.dig('auth', 'applicationPassword'), Updox.configuration.application_password)
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
      body = read_test_file(file)
    end

    response[:body] = body if (false == body.nil?)

    return response
  end

  def stub_updox_request(endpoint)
    return stub_request(:post, "#{Updox::Connection.base_uri}#{endpoint}")
  end

  def stub_updox(endpoint: '/ping', response: nil)
    response ||= build_response(body: {})

    @stub = stub_updox_request(endpoint).to_return(response)
  end
end
