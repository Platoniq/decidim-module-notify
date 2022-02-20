# frozen_string_literal: true

module Decidim
  module Notify
    # This cell renders the card for an instance of a Notify Participant
    class ParticipantCell < Decidim::ViewModel
      def code
        return model.code if model.is_a? Author

        Author.find_by(user: model, component: current_component)&.code if model
      end

      def name
        model&.name
      end

      def avatar_url
        model.attached_uploader(:avatar).path(variant: :profile) if model.respond_to?(:attached_uploader)
      end

      def current_component
        context&.dig(:current_component) || controller&.current_component
      end
    end
  end
end
