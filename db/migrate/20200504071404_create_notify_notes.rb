class CreateNotifyNotes < ActiveRecord::Migration[5.2]
  def change
    create_table :decidim_notify_notes do |t|
    	t.string :body
    end
  end
end
