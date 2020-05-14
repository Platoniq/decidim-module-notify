# frozen_string_literal: true

module Decidim
  module Notify
    # The data store for a Chapter in the Decidim::Notify component.
    class Chapter < ApplicationRecord
      include BelongsToNotifyComponent

      self.table_name = :decidim_notify_chapters

      has_many :notes,
               foreign_key: "decidim_notify_chapter_id",
               class_name: "Decidim::Notify::Note"

      validates :title, presence: true
      validates :title, uniqueness: { scope: :decidim_component_id }

      default_scope { order(created_at: :desc) }
    end
  end
end
