# frozen_string_literal: true

module Appcenter
  module Webhooks
    class RegistrationsController < BaseController
      def create
        encoded_token = request.headers["Authorization"]

        begin
          app_code = Tokenizer::Appcenter.decode_jwt_and_get_app_code(encoded_token)
          app_code = "unknown_app_code" if app_code.blank?
        rescue JWT::DecodeError
          render_error_json_response(:unauthorized, "Invalid credential") && return
        end

        params_app_code = "unknown_app_code_params"
        params[:app_code] = params_app_code if params[:app_code].blank?

        unless ActiveSupport::SecurityUtils.secure_compare(app_code, params[:app_code])
          render_error_json_response(:unauthorized, "Invalid app code") && return
        end

        tenant = Tenant.find_or_initialize_by(code: params[:app_code]) do |t|
          t.name = params[:app_name]
          t.admin_email = params[:admin_email]
          t.secret_key = params[:app_secret]
          t.admin_token = params[:admin_token]
          t.admin_sdk_token = params[:qiscus_sdk_token]
          t.active = true
        end

        (render_success_json_response && return) unless tenant.changed?
        (render_success_json_response && return) if tenant.save # this will return false if there is error in validation

        render_error_json_response(:unprocessable_entity, tenant.errors.full_messages.to_sentence) && return
      end
    end
  end
end
