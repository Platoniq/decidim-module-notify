# frozen_string_literal: true

module Decidim
  module Notify
    class ChaptersController < Decidim::Notify::ApplicationController
      include FormFactory
      include NeedsAjaxRescue
      include Broadcasts

      def update
        enforce_permission_to :create, :chapter

        @form = form(ChapterForm).from_params(params)
        UpdateChapter.call(@form) do
          on(:ok) do |chapter, _old_title|
            broadcast_update_chapter chapter

            render json: { message: "✔" }
          end
          on(:invalid) do |message|
            render json: { message: t("update.error", scope: "decidim.notify.chapter", message: message) }, status: :unprocessable_entity
          end
        end
      end

      def destroy
        enforce_permission_to :destroy, :chapter

        DeleteChapter.call(params[:id]) do
          on(:ok) do
            broadcast_destroy_chapter params[:id]
            render json: { message: "✔" }
          end
          on(:invalid) do |message|
            render json: { message: t("destroy.error", scope: "decidim.notify.chapter", message: message) }, status: :unprocessable_entity
          end
        end
      end
    end
  end
end
