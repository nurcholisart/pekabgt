# frozen_string_literal: true

class AddActiveToEmbeddings < ActiveRecord::Migration[7.0]
  def change
    add_column :embeddings, :active, :boolean, null: false, default: false
  end
end
