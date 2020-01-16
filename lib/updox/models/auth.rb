module Updox
  module Models
    class Auth
      def self.build_auth(application_id: '', application_password: '')
        {
          auth: {
            applicationId: application_id,
            applicationPassword: application_password
          }
        }
      end
    end
  end
end
