# frozen_string_literal: true

class AddContentToEmbeddings < ActiveRecord::Migration[7.0]
  def change
    add_column :embeddings, :content, :string
  end
end
