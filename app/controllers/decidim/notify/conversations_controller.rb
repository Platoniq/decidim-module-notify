# frozen_string_literal: true

module Decidim
  module Notify
    class ConversationsController < Decidim::Notify::ApplicationController
      include FormFactory

      def index
        @notes = Note.for(current_component)
        @form = form(NoteForm).instance
      end

      def create
        @form = form(NoteForm).from_params(params)
        CreateNote.call(@form) do
          on(:ok) do |note|
            broadcast_note note
            render json: { message: "✔" }
          end
          on(:invalid) do |message|
            render json: { message: I18n.t("decidim.notify.conversations.error", message: message) }, status: :unprocessable_entity
          end
        end
      end

      def broadcast_note(note)
        html = render_to_string(partial: "note", locals: { note: note })
        Decidim::Notify.server.broadcast("notify-notes-#{current_component.id}", html)
      end
    end
  end
end
