# frozen_string_literal: true

# Create items
class CreateItems < ActiveRecord::Migration[7.1]
  def change
    create_table :items do |t|
      t.string :title, null: false
      t.text :description

      t.timestamps
    end
    add_index :items, :title, unique: true
    add_index :items, :created_at
    add_index :items, :updated_at
    add_index :items, %{to_tsvector('english', title)}, using: :gin
    add_index :items, %{to_tsvector('english', description)}, using: :gin
  end
end
