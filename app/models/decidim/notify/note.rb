# frozen_string_literal: true

module Decidim
  module Notify
    # The data store for a Note in the Decidim::Notify component.
    class Note < ApplicationRecord
      include BelongsToNotifyComponent

      self.table_name = :decidim_notify_notes

      belongs_to :component, foreign_key: "decidim_component_id", class_name: "Decidim::Component"
      belongs_to :author, foreign_key: "decidim_author_id", class_name: "Decidim::User", optional: true
      belongs_to :creator, foreign_key: "decidim_creator_id", class_name: "Decidim::User"
      belongs_to :chapter, foreign_key: "decidim_notify_chapter_id", class_name: "Decidim::Notify::Chapter", optional: true

      validates :creator, presence: true

      default_scope { order(decidim_notify_chapter_id: :asc, created_at: :desc) }

      scope :orphan, -> { where(author: nil) }
      scope :unclassified, -> { where(chapter: nil) }
    end
  end
end
