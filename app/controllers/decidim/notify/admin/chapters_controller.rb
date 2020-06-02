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

        def update
          enforce_permission_to :update, :chapter, chapter: current_chapter
        end

        def destroy
          enforce_permission_to :destroy, :chapter, chapter: current_chapter
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
