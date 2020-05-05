# frozen_string_literal: true

module Decidim
  module Notify
    class ConversationsController < ApplicationController
      include FormFactory

      def index
        @notes = Note.for(current_component)
        @form = form(NoteForm).from_params(params)
      end

      def create
        @form = form(NoteForm).from_params(params)
        note = Note.create!(@form.attributes)
        # note = Note.new(@form.attributes)

        broadcast note
        redirect_to conversations_path
      end

      private

      def broadcast(note)
        html = render_to_string(partial: "note", locals: { note: note })
        Decidim::Notify.server.broadcast("notify-notes-#{current_component.id}", html)
      end
    end
  end
end
