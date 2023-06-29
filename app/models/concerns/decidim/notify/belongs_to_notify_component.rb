# frozen_string_literal: true

require "active_support/concern"

module Decidim
  module Notify
    # A concern with the components needed when you want a model to be have a questionnaire attached
    module BelongsToNotifyComponent
      extend ActiveSupport::Concern

      included do
        belongs_to :component, foreign_key: "decidim_component_id", class_name: "Decidim::Component"

        validate :component_is_notify

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
end
