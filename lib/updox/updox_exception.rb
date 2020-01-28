module Updox
  class UpdoxException < Exception
    def self.from_response(response, msg: nil)
      exception_msg = "Failed #{msg}:"
      exception_msg << " HTTP code: #{response.code}"

      begin
        error_response = JSON.parse(response.body)

        if error_response.is_a?(Hash)
          if error_response.include?('responseMessage')
            exception_msg << " MSG: #{error_response['responseMessage']}"
          end

          if error_response.include?('responseCode')
            exception_msg << " UPDOX CODE: #{error_response['responseCode']}"
          end
        else
          exception_msg << " MSG: #{error_response}"
        end
      rescue JSON::ParserError
        exception_msg << " MSG: #{response.body}"
      end

      return UpdoxException.new(exception_msg)
    end
  end
end
