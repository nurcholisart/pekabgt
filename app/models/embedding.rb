# frozen_string_literal: true

# == Schema Information
#
# Table name: embeddings
#
#  id         :bigint           not null, primary key
#  tenant_id  :bigint           not null
#  version    :string
#  cost       :string
#  faiss_url  :string
#  pkl_url    :string
#  status     :integer          default("draft")
#  notes      :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  content    :string
#  active     :boolean          default(FALSE), not null
#
class Embedding < ApplicationRecord
  validates :tenant, presence: true

  attribute :version, :string, default: -> { ULID.generate.downcase }
  attribute :cost, :string, default: "0"
  attribute :faiss_url, :string, default: "-"
  attribute :pkl_url, :string, default: "-"
  attribute :notes, :string, default: "-"

  belongs_to :tenant

  enum status: { draft: 0, in_progress: 1, success: 2, failed: 3 }

  def hashed_contents
    JSON.parse(content || [].to_json, object_class: HashWithIndifferentAccess)
  end

  def can_be_activated?
    faiss_url.present? && pkl_url.present? && faiss_url != "-" && pkl_url != "-"
  end

  def can_be_trained?
    content.present?
  end

  def model_ready?
    faiss_url && pkl_url && faiss_url != "-" && pkl_url != "-"
  end

  def activate
    update(active: true)
  end

  def deactivate
    update(active: false)
  end
end
