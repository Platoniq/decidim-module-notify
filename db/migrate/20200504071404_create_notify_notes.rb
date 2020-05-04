# frozen_string_literal: true

class CreateNotifyNotes < ActiveRecord::Migration[5.2]
  def change
    create_table :decidim_notify_notes do |t|
      t.string :body, null: false

      t.timestamps
    end
  end
end
