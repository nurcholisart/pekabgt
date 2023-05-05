# frozen_string_literal: true

module Appcenter
  class SessionsController < BaseController
    # This method is entrypoint of preferences page in appcenter. So it
    # will do authentication based on jwt encoded token in path params
    def show
      encoded_token = params[:id]
      render_unauthorized_page && return if encoded_token.blank?

      begin
        app_code = Tokenizer::Appcenter.decode_jwt_and_get_app_code(encoded_token)
      rescue JWT::DecodeError
        render_unauthorized_page && return
      end

      tenant = Tenant.find_by(code: app_code)
      render("errors/not_found", status: :unauthorized) && return if tenant.blank?

      create_session(tenant)
      redirect_to appcenter_accounts_path
    end
  end
end
