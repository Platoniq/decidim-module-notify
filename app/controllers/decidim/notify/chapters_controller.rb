# frozen_string_literal: true

module Decidim
  module Notify
    class ChaptersController < Decidim::Notify::ApplicationController
      include FormFactory
      include NeedsAjaxRescue
      include Broadcasts

      def update
        enforce_permission_to :create, :chapters

        @form = form(ChapterForm).from_params(params)
        UpdateChapter.call(@form) do
          on(:ok) do |chapter, _old_title|
            broadcast_update_chapter chapter

            render json: { message: "✔" }
          end
          on(:invalid) do |message|
            render json: { message: I18n.t("decidim.notify.chapters.update.error", message: message) }, status: :unprocessable_entity
          end
        end
      end

      def destroy
        enforce_permission_to :destroy, :chapters

        DeleteChapter.call(params[:id]) do
          on(:ok) do
            broadcast_destroy_chapter params[:id]
            render json: { message: "✔" }
          end
          on(:invalid) do |message|
            render json: { message: I18n.t("decidim.notify.chapters.destroy.error", message: message) }, status: :unprocessable_entity
          end
        end
      end
    end
  end
end
