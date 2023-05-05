# frozen_string_literal: true

module Pekabgt
  class Config
    class << self
      def appcenter_jwt_key
        ENV["APPCENTER_JWT_KEY"]
      end
    end
  end
end
