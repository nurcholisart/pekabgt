# frozen_string_literal: true

class CustomerMessageJob < ApplicationJob
  retry_on StandardError, attempts: 3, wait: 5.seconds
  queue_as :default

  def perform(tenant_id, request_body)
    # @type [Tenant]
    tenant = Tenant.find_by(id: tenant_id)
    return if tenant.blank?

    qismo = tenant.qismo_client

    webhook = Qismo::WebhookRequests::OnMessageForBotSent.new(JSON.parse(request_body))

    return if webhook.payload.message.type != "text"

    # create customer message
    customer_message = tenant.messages.create!(
      sender_id: webhook.payload.from.email,
      sender_type: "customer",
      sender_name: webhook.payload.from.name,
      qiscus_room_id: webhook.payload.room.id,
      content: webhook.payload.message.text
    )

    embedding = active_embedding(tenant)
    if embedding.blank?
      tenant.messages.create(
        sender_id: "chatbot",
        sender_type: "chatbot",
        sender_name: "Chatbot",
        qiscus_room_id: webhook.payload.room.id,
        content: "We have no embedding yet. Please create one!"
      )

      return
    end

    # create chatbot message
    chatbot_message = tenant.messages.create(
      sender_id: "chatbot",
      sender_type: "chatbot",
      sender_name: "Chatbot",
      qiscus_room_id: webhook.payload.room.id,
      content: "AI is generating content...",
      status: "draft"
    )

    peka = Peka.new(tenant.code, tenant.openai_api_key)
    result = peka.query_message(customer_message.content, embedding.faiss_url, embedding.pkl_url)

    answer = result[:answer]
    answer = answer.gsub("#small_talk", "")
    answer = answer.gsub("#end_chat", "")
    answer = answer.gsub("#assign_agent", "")
    answer = answer.strip

    chatbot_message.update(content: answer, status: "published")

    qismo.allocate_and_assign_agent(room_id: webhook.payload.room.id) if "#assign_agent".in?(result[:answer])

    qismo_room = qismo.get_room(room_id: webhook.payload.room.id)

    qismo.resolve_room(room_id: webhook.payload.room.id) if "#end_chat".in?(result[:answer]) && qismo_room.is_waiting

    true
  end

  private

  #
  # @param [Tenant] tenant
  #
  # @return [Embedding]
  #
  def active_embedding(tenant)
    embedding = tenant.embeddings.where(active: true).first
    embedding = tenant.embeddings.first if embedding.blank?

    embedding
  end
end
