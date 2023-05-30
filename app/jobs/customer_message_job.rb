# frozen_string_literal: true

class CustomerMessageJob < ApplicationJob
  retry_on StandardError, attempts: 3, wait: 5.seconds
  queue_as :default

  def perform(tenant_id, request_body)
    puts "SAMPE 8====================================="
    # @type [Tenant]
    tenant = Tenant.find_by(id: tenant_id)
    return if tenant.blank?

    puts "SAMPE 13====================================="

    qismo = tenant.qismo_client

    webhook = Qismo::WebhookRequests::OnMessageForBotSent.new(JSON.parse(request_body))

    puts "SAMPE 19====================================="

    return if webhook.payload.message.type != "text"

    puts "SAMPE 23====================================="

    # create customer message
    customer_message = tenant.messages.create!(
      sender_id: webhook.payload.from.email,
      sender_type: "customer",
      sender_name: webhook.payload.from.name,
      qiscus_room_id: webhook.payload.room.id,
      content: webhook.payload.message.text
    )

    puts "SAMPE 34====================================="

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

    puts "SAMPE 49====================================="

    # create chatbot message
    if tenant.agent_assistant_enabled
      chatbot_message = tenant.messages.create(
        sender_id: "chatbot",
        sender_type: "chatbot",
        sender_name: "Chatbot",
        qiscus_room_id: webhook.payload.room.id,
        content: "AI is generating content...",
        status: "draft"
      )
    end

    puts "SAMPE 63====================================="

    peka = Peka.new(tenant.code, tenant.openai_api_key)
    result = peka.query_message(
      customer_message.content,
      embedding.faiss_url,
      embedding.pkl_url,
      tenant.chatbot_name,
      tenant.chatbot_description
    )

    answer = result[:answer]
    answer = answer.gsub("#small_talk", "")
    answer = answer.gsub("#end_chat", "")
    answer = answer.gsub("#assign_agent", "")
    answer = answer.gsub("#dont_know", "")
    answer = answer.strip

    puts "SAMPE 74====================================="

    chatbot_message.update(content: answer, status: "published") if tenant.agent_assistant_enabled

    puts "SAMPE 78====================================="

    if tenant.chatbot_enabled
      qismo.send_bot_message(
        room_id: webhook.payload.room.id,
        message: answer
      )
    end

    # qismo.allocate_and_assign_agent(room_id: webhook.payload.room.id) if "#assign_agent".in?(result[:answer])
    # qismo.resolve_room(room_id: webhook.payload.room.id) if tenant.chatbot_enabled && "#end_chat".in?(result[:answer])

    true
  rescue StandardError => e
    Rails.logger.error("ERROR")
    Rails.logger.error(e.inspect)
    false
  end

  private

  #
  # @param [Tenant] tenant
  #
  # @return [Embedding]
  #
  def active_embedding(tenant)
    embedding = tenant.embeddings.where(active: true).last
    embedding = tenant.embeddings.first if embedding.blank?

    embedding
  end
end
