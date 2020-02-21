module Updox
  class UpdoxException < Exception
    def self.from_response(response, msg: nil)
      data = {}
      exception_msg = "Failed #{msg}:"
      data['HTTP_CODE'] = response.code

      begin
        error_response = JSON.parse(response.body)

        if error_response.is_a?(Hash)
          if error_response.include?('responseMessage')
            data['MSG'] = error_response['responseMessage']
          end

          if error_response.include?('responseCode')
            data['UPDOX_CODE'] = error_response['responseCode']
          end
        else
          data['MSG'] = error_response
        end
      rescue JSON::ParserError
        data['MSG'] = response.body
      end

      data.each {|k,v| exception_msg << " #{k} '#{v}'" }

      return UpdoxException.new(exception_msg)
    end
  end
end
