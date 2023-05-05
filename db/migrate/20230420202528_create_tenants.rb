# frozen_string_literal: true

class CreateTenants < ActiveRecord::Migration[7.0]
  def change
    create_table :tenants do |t|
      t.string :name, null: false
      t.string :admin_email, null: false
      t.boolean :active, default: true

      t.string :code, null: false, index: { unique: true }
      t.string :secret_key, null: false
      t.string :admin_token, null: false
      t.string :admin_sdk_token, null: false

      t.jsonb :preferences

      t.timestamps
    end
  end
end
