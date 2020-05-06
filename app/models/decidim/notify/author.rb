# frozen_string_literal: true

module Decidim
  module Notify
    # The data store for a Author in the Decidim::Notify component.
    class Author < ApplicationRecord
      self.table_name = :decidim_notify_authors

      belongs_to :user, foreign_key: "decidim_user_id", class_name: "Decidim::User", optional: true
      belongs_to :component, foreign_key: "decidim_component_id", class_name: "Decidim::Component"

      validates :component, presence: true
      validates :user, uniqueness: { scope: :decidim_component_id }
      validates :code, numericality: { greater_than_or_equal_to: 1 }, uniqueness: { scope: :decidim_component_id }

      validate :component_is_notify

      delegate :name, :nickname, :organization, :avatar, to: :user
      delegate :profile_url, :avatar_url, to: :user, allow_nil: true

      default_scope { order(code: :asc) }

      scope :note_takers, -> { where(admin: true) }

      def self.for(component)
        where(component: component)
      end

      private

      def component_is_notify
        return unless component

        errors.add(:component, :invalid) unless component.manifest.name == :notify
      end
    end
  end
end
