# frozen_string_literal: true

module Decidim
  module Notify
    class ConversationsController < Decidim::Notify::ApplicationController
      include FormFactory
      include NeedsAjaxRescue
      include Broadcasts

      helper_method :chapters, :active_chapter

      def index
        return render :private unless allowed_to? :index, :notes

        @unclassified = Chapter.new(notes: unclassified_notes)
        @participants = Author.for(current_component).participants
        @note_takers = Author.for(current_component).note_takers
        @form = form(NoteForm).instance
      end

      def create
        enforce_permission_to :create, :notes

        @form = form(NoteForm).from_params(params)
        CreateNote.call(@form) do
          on(:ok) do |note, new_chapter|
            broadcast_create_chapter new_chapter if new_chapter
            broadcast_create_note note

            render json: { message: "✔" }
          end
          on(:invalid) do |message|
            render json: { message: I18n.t("decidim.notify.conversations.create.error", message:) }, status: :unprocessable_entity
          end
        end
      end

      def update
        enforce_permission_to :update, :notes

        @form = form(NoteForm).from_params(params)
        UpdateNote.call(@form) do
          on(:ok) do |note, new_chapter|
            broadcast_create_chapter new_chapter if new_chapter
            broadcast_update_note note

            render json: { message: "✔" }
          end
          on(:invalid) do |message|
            render json: { message: I18n.t("decidim.notify.conversations.update.error", message:) }, status: :unprocessable_entity
          end
        end
      end

      def destroy
        enforce_permission_to :destroy, :notes

        DeleteNote.call(params[:id]) do
          on(:ok) do
            broadcast_destroy_note params[:id]
            render json: { message: "✔" }
          end
          on(:invalid) do |message|
            render json: { message: I18n.t("decidim.notify.conversations.destroy.error", message:) }, status: :unprocessable_entity
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

              render json: query.all.collect { |u| { id: u.code, name: u.name, avatar: u.attached_uploader(:avatar).path, nickname: u.nickname, text: format_user_name(u) } }
            else
              render json: []
            end
          end
        end
      end

      private

      def chapters
        @chapters ||= Chapter.for(current_component).all
      end

      def active_chapter
        chapters.find(&:active)
      end

      def unclassified_notes
        @unclassified_notes ||= Note.for(current_component).unclassified
      end

      def format_user_name(user)
        "#{user.name} (@#{user.nickname})"
      end
    end
  end
end
