# frozen_string_literal: true

# == Schema Information
#
# Table name: messages
#
#  id             :bigint           not null, primary key
#  tenant_id      :bigint           not null
#  uid            :string           not null
#  sender_id      :string           not null
#  sender_name    :string
#  sender_type    :integer          not null
#  qiscus_room_id :bigint           not null
#  cost           :float
#  content        :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  status         :integer          default(1), not null
#
class Message < ApplicationRecord
  attribute :uid, :string, default: -> { ULID.generate.downcase }
  attribute :content, :string, default: "typing..."

  validates :uid, :sender_id, :sender_name, :sender_type, :qiscus_room_id, presence: true

  enum sender_type: { customer: 0, chatbot: 1 }
  enum status: { draft: 0, published: 1, sent_to_qiscus: 2 }

  belongs_to :tenant

  after_create_commit :append_new_message_to_ui
  after_update_commit :update_message_to_ui

  def append_new_message_to_ui
    broadcast_append_to(
      "room_#{qiscus_room_id}_messages",
      partial: "appcenter/rooms/message",
      locals: { message: self },
      target: "room_#{qiscus_room_id}_messages"
    )
  end

  def update_message_to_ui
    broadcast_update_to(
      "room_#{qiscus_room_id}_messages",
      partial: "appcenter/rooms/message",
      locals: { message: self },
      target: "message_#{id}"
    )
  end
end
