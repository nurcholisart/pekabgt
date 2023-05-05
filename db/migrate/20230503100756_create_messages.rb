# frozen_string_literal: true

class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.references :tenant, foreign_key: true, null: false
      t.string :uid, index: { unique: true }, null: false
      t.string :sender_id, index: true, null: false
      t.string :sender_name
      t.integer :sender_type, null: false
      t.bigint :qiscus_room_id, null: false
      t.float :cost
      t.text :content

      t.timestamps
    end
  end
end
