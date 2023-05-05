# frozen_string_literal: true

module Appcenter
  class MessagesController < BaseController
    before_action :authenticate_current_tenant

    def edit
      
    end

    def update
      message = Current.tenant.messages.find_by(id: params[:id], qiscus_room_id: params[:room_id])
      head(:ok) && return if message.blank?

      message.update(content: "New message suggestion is being generated...")

      head :ok
    end
  end
end
