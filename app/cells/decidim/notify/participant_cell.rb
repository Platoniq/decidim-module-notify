# frozen_string_literal: true

module Decidim
  module Notify
    # This cell renders the card for an instance of a Notify Participant
    class ParticipantCell < Decidim::ViewModel
      property :code
      property :name
      property :nickname
      property :profile_url

      private

      def has_profile?
        model.profile_url.present?
      end
    end
  end
end
