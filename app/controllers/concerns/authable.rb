# frozen_string_literal: true

module Authable
  def create_session(tenant)
    session[:current_tenant_id] = tenant.signed_id(expires_in: 24.hours, purpose: "appcenter-dashboard")
  end

  def authenticated?
    current_tenant_id = session[:current_tenant_id]
    current_tenant_id.present?
  end

  def authenticate_current_tenant
    current_tenant_id = session[:current_tenant_id]

    # Just for development
    if current_tenant_id.blank? && Rails.env.development?
      seed_tenant = Tenant.find_by(code: "ergav-4oqumerwmn4r1ud")

      if seed_tenant.blank?
        Rails.application.load_seed if seed_tenant.blank?
        seed_tenant = Tenant.find_by(code: "ergav-4oqumerwmn4r1ud")
      end

      create_session(seed_tenant)
      redirect_to appcenter_accounts_path
      return
    end

    render_unauthorized_page && return if current_tenant_id.blank?

    tenant = Tenant.find_signed(current_tenant_id, purpose: "appcenter-dashboard")
    render_unauthorized_page && return if tenant.blank?

    Current.tenant = tenant
  end

  def render_unauthorized_page
    render "errors/unauthorized", layout: "errors", status: :unauthorized
  end
end
