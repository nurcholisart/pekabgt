# frozen_string_literal: true

module Webhooks
  class ChatbotController < ::ApplicationController
    skip_before_action :verify_authenticity_token

    def update
      tenant = Tenant.find_by(code: params[:id])
      if tenant.blank?
        render json: {
          message: "ignored. app code not found"
        }, status: :ok
        return
      end

      CustomerMessageJob.perform_later(tenant.id, request.raw_post)

      render json: {
        ok: true
      }, status: :ok
    end
  end
end
