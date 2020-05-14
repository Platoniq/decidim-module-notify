# frozen_string_literal: true

module Decidim
  module Notify
    # The data store for a Author in the Decidim::Notify component.
    class Author < ApplicationRecord
      include BelongsToNotifyComponent

      self.table_name = :decidim_notify_authors

      belongs_to :user, foreign_key: "decidim_user_id", class_name: "Decidim::User", optional: true

      validates :user, uniqueness: { scope: :decidim_component_id }
      validates :code, numericality: { greater_than_or_equal_to: 1 }, uniqueness: { scope: :decidim_component_id }

      delegate :name, :nickname, :organization, :avatar, to: :user
      delegate :profile_url, :avatar_url, to: :user, allow_nil: true

      default_scope { order(code: :asc) }

      scope :note_takers, -> { where(admin: true) }

      def notes
        Note.where(decidim_author_id: decidim_user_id)
      end
    end
  end
end
