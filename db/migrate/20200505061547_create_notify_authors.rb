# frozen_string_literal: true

class CreateNotifyAuthors < ActiveRecord::Migration[5.2]
  def change
    create_table :decidim_notify_authors do |t|
      t.references :decidim_user, index: { name: "index_decidim_notify_authors_on_decidim_user_id" }
      t.references :decidim_component, index: { name: "index_decidim_notify_authors_on_decidim_component_id" }

      t.integer :code, null: false, default: 0, index: { name: "index_decidim_notify_authors_on_code" }
      t.string :full_name
      t.string :avatar
      t.string :email

      t.timestamps
    end
  end
end
