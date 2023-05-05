# frozen_string_literal: true

module Appcenter
  module Webhooks
    class BaseController < ::ApplicationController
      skip_before_action :verify_authenticity_token

      def render_success_json_response(message = "Successfully saved data")
        render json: {
          message: message
        }, status: :ok
      end

      def render_error_json_response(status, message)
        render json: {
          message: message
        }, status: status
      end
    end
  end
end
