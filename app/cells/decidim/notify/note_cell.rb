# frozen_string_literal: true

module Decidim
  module Notify
    # This cell renders the card for an instance of a Notify Participant
    class NoteCell < Decidim::ViewModel
      property :body
      property :author
      property :creator
      property :user
      property :created_at

      def notify_author
        Author.find_by(user: model.author)
      end
    end
  end
end
