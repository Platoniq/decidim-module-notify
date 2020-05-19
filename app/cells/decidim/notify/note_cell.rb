# frozen_string_literal: true

module Decidim
  module Notify
    # This cell renders the card for an instance of a Notify Participant
    class NoteCell < Decidim::ViewModel
      include Decidim::LayoutHelper

      property :id
      property :body
      property :author
      property :creator
      property :user
      property :chapter
      property :created_at

      def notify_author
        Author.find_by(user: model.author, component: model.component)
      end

      def note_taker?
        return unless current_user

        Author.for(model.component).note_takers.find_by(user: current_user)
      end

      def note_author_class
        return "by-note-taker" if note_taker?

        "by-participant"
      end

      def edit_path
        EngineRouter.main_proxy(model.component).conversation_path(model.id)
      end
    end
  end
end
