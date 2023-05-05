# frozen_string_literal: true

class CreateEmbeddings < ActiveRecord::Migration[7.0]
  def change
    create_table :embeddings do |t|
      t.references :tenant, foreign_key: true, null: false
      t.string :version
      t.string :cost
      t.string :faiss_url
      t.string :pkl_url
      t.integer :status, default: 0
      t.text :notes

      t.timestamps
    end
  end
end
