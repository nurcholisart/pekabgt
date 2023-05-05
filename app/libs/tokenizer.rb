# frozen_string_literal: true

class Tokenizer
  class Appcenter
    class << self
      # @return [String]
      def decode_jwt_and_get_app_code(encoded_token)
        decoded_token = decode_jwt(encoded_token)
        payload = ActiveSupport::HashWithIndifferentAccess.new(decoded_token.first)
        payload[:app_code]
      end

      def decode_jwt(encoded_token)
        JWT.decode(encoded_token, Pekabgt::Config.appcenter_jwt_key, true)
      end
    end
  end
end
