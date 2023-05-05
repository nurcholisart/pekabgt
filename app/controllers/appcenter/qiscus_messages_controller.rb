# frozen_string_literal: true

module Appcenter
  class QiscusMessagesController < BaseController
    include ApplicationHelper

    before_action :authenticate_current_tenant

    def update
      message_id = params[:id]
      qiscus_room_id = params[:room_id]

      message = Message.find_by(id: message_id, qiscus_room_id: qiscus_room_id)
      if message.blank?
        head :ok
        return
      end

      if message.sender_type != "chatbot"
        head :ok
        return
      end

      qismo = Current.tenant.qismo_client

      content = remove_action_message(message.content)
      qismo.send_bot_message(room_id: message.qiscus_room_id, message: content)
      message.update(status: "sent_to_qiscus")

      redirect_to appcenter_room_path(message.qiscus_room_id, anchor: dom_id(message))
    end

    private

    def create_params
      params.permit(:message_id, :room_id)
    end
  end
end
