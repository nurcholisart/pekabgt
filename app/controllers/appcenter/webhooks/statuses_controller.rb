# frozen_string_literal: true

module Appcenter
  module Webhooks
    class StatusesController < BaseController
      def create
        encoded_token = request.headers["Authorization"]

        begin
          app_code = Tokenizer::Appcenter.decode_jwt_and_get_app_code(encoded_token)
        rescue JWT::DecodeError
          render_error_json_response(:unauthorized, "Invalid credential") && return
        end

        unless ActiveSupport::SecurityUtils.secure_compare(app_code, create_params[:app_code])
          render_error_json_response(:unauthorized, "Invalid app code") && return
        end

        tenant = Tenant.find_by(code: params[:app_code])
        if tenant.blank?
          render_error_json_response(:unauthorized,
                                     "Invalid app code or app is not registered") && return
        end

        if tenant.update(name: params[:app_name], admin_email: params[:admin_email], code: params[:code],
                         secret_key: params[:secret_key], admin_token: params[:admin_token],
                         admin_sdk_token: params[:qiscus_sdk_token], active: params[:status])
          render_success_json_response
        else
          render_error_json_response(:unprocessable_entity, tenant.errors.full_messages.to_sentence)
        end
      end
    end
  end
end
