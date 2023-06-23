# frozen_string_literal: true

class CustomerMessageJob < ApplicationJob
  retry_on StandardError, attempts: 3, wait: 5.seconds
  queue_as :default

  def perform(tenant_id, request_body)
    ActiveRecord::Base.transaction do
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

      peka = Peka.new(tenant.code, tenant.openai_api_key)
      success, result = peka.query_message_v2(
        session_id: webhook.payload.room.id.to_s,
        question: customer_message.content,
        system_prompt: tenant.system_prompt || Tenant::DEFAULT_SYSTEM_PROMPT,
        faiss_url: embedding.faiss_url,
        pkl_url: embedding.pkl_url
      )

      raise result unless success

      puts result

      answer = result[:answer]
      answer = begin
        Nokogiri::HTML(answer).text
      rescue StandardError
        answer
      end

      answer = answer.gsub("#small_talk", "")
      answer = answer.gsub("#end_chat", "")
      answer = answer.gsub("#assign_agent", "")
      answer = answer.gsub("#dont_know", "")
      answer = answer.strip

      if tenant.append_source_documents? && result[:source_documents].present?
        source_documents = result[:source_documents]
        source_document_message = ""

        source_documents.each do |document|
          source_document_message += "- #{document[:metadata][:link]}\n"
        end

        answer += "\n\nArtikel Terkait:\n#{source_document_message}"
      end

      chatbot_message.update(content: answer, status: "published") if tenant.agent_assistant_enabled

      if tenant.chatbot_enabled
        qismo.send_bot_message(
          room_id: webhook.payload.room.id,
          message: answer
        )
      end
    end

    true
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
