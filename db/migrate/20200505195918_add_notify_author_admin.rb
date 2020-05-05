# frozen_string_literal: true

class AddNotifyAuthorAdmin < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_notify_authors, :admin, :boolean, default: false
  end
end
