# frozen_string_literal: true

# == Schema Information
#
# Table name: tenants
#
#  id              :bigint           not null, primary key
#  name            :string           not null
#  admin_email     :string           not null
#  active          :boolean          default(TRUE)
#  code            :string           not null
#  secret_key      :string           not null
#  admin_token     :string           not null
#  admin_sdk_token :string           not null
#  preferences     :jsonb
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class Tenant < ApplicationRecord
  DEFAULT_CHATBOT_NAME = "Peka"
  DEFAULT_CHATBOT_DESCRIPTION = "You are an AI customer service agent for answering question about Qiscus"

  store_attribute :preferences, :openai_api_key, :string, default: "undefined_api_key"
  store_attribute :preferences, :chatbot_enabled, :boolean, default: false
  store_attribute :preferences, :agent_assistant_enabled, :boolean, default: false
  store_attribute :preferences, :chatbot_name, :string, default: DEFAULT_CHATBOT_NAME
  store_attribute :preferences,
                  :chatbot_description,
                  :string,
                  default: DEFAULT_CHATBOT_DESCRIPTION

  validates :name, :admin_email, :code, :secret_key, :admin_token, :admin_sdk_token, presence: true
  validates :code, uniqueness: true

  has_many :embeddings, dependent: :destroy
  has_many :messages, dependent: :destroy

  # return [Qismo::Client]
  def qismo_client
    Qismo::Client.new(app_id: code, secret_key: secret_key, admin_email: admin_email)
  end
end
