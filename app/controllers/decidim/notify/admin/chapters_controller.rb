# frozen_string_literal: true

module Decidim
  module Notify
    module Admin
      class ChaptersController < Admin::ApplicationController
        include Broadcasts

        helper_method :chapters

        def new
          enforce_permission_to :create, :chapter
          @form = form(ChapterForm).instance
        end

        def edit
          enforce_permission_to :update, :chapter, chapter: current_chapter
          @form = form(ChapterForm).from_model(current_chapter)
        end

        def create
          enforce_permission_to :create, :chapter

          @form = form(ChapterForm).from_params(params)

          CreateChapter.call(@form) do
            on(:ok) do |chapter|
              flash[:notice] = I18n.t("chapters.create.success", scope: "decidim.notify.admin")

              broadcast_create_chapter chapter
              redirect_to EngineRouter.admin_proxy(current_component).chapters_path
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("chapters.create.error", scope: "decidim.notify.admin")
              render :new
            end
          end
        end

        def update
          enforce_permission_to :update, :chapter, chapter: current_chapter
          @form = form(ChapterForm).from_params(params)

          UpdateChapter.call(@form, current_chapter) do
            on(:ok) do
              flash[:notice] = I18n.t("chapters.update.success", scope: "decidim.notify.admin")

              broadcast_update_chapter current_chapter
              redirect_to EngineRouter.admin_proxy(current_component).chapters_path
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("chapters.update.error", scope: "decidim.notify.admin")
              render :edit
            end
          end
        end

        def destroy
          enforce_permission_to :destroy, :chapter, chapter: current_chapter

          DestroyChapter.call(current_chapter) do
            on(:ok) do
              flash[:notice] = I18n.t("chapters.destroy.success", scope: "decidim.notify.admin")

              broadcast_destroy_chapter params[:id]
              redirect_to EngineRouter.admin_proxy(current_component).chapters_path
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("chapters.destroy.error", scope: "decidim.notify.admin")
              redirect_to EngineRouter.admin_proxy(current_component).chapters_path
            end
          end
        end

        private

        def chapters
          Chapter.for(current_component)
        end

        def current_chapter
          @current_chapter ||= Chapter.find(params[:id])
        end
      end
    end
  end
end
