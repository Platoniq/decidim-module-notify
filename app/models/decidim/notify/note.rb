# frozen_string_literal: true

module Decidim
  module Notify
    # The data store for a Note in the Decidim::Notify component.
    class Note < ApplicationRecord
      self.table_name = :decidim_notify_notes

      belongs_to :author, foreign_key: "decidim_notify_author_id", class_name: "Decidim::Notify::Author"
      belongs_to :creator, foreign_key: "decidim_user_id", class_name: "Decidim::User"
	    belongs_to :component, foreign_key: "decidim_component_id", class_name: "Decidim::Component"

      validates :author, :creator, :component, presence: true
      validate :component_is_notify

      default_scope { order(created_at: :desc) }

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
