# frozen_string_literal: true

module Decidim
  module Notify
    class ConversationsController < Decidim::Notify::ApplicationController
      include FormFactory
      include NeedsAjaxRescue

      def index
        @notes = Note.for(current_component)
        @participants = Author.for(current_component)
        @form = form(NoteForm).instance
      end

      def create
        enforce_permission_to :create, :notes

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

      def users
        enforce_permission_to :create, :notes

        respond_to do |format|
          format.json do
            if (term = params[:term].to_s).present?
              query = Author.for(current_component).joins(:user)
              query = query.where("decidim_notify_authors.code=:code OR decidim_users.name ILIKE :term OR decidim_users.nickname ILIKE :term", code: term.to_i, term: "%#{term}%")

              render json: query.all.collect { |u| { id: u.code, text: format_user_name(u) } }
            else
              render json: []
            end
          end
        end
      end

      private

      def format_user_name(user)
        "#{user.code} - #{user.name} (@#{user.nickname})"
      end

      def broadcast_note(note)
        html = render_to_string(partial: "note", locals: { note: note })
        Decidim::Notify.server.broadcast("notify-notes-#{current_component.id}", html)
      end
    end
  end
end
