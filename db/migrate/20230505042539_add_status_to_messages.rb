# frozen_string_literal: true

class AddStatusToMessages < ActiveRecord::Migration[7.0]
  def change
    add_column :messages, :status, :integer, null: false, default: 1
  end
end
