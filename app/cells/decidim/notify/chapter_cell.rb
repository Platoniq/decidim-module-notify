# frozen_string_literal: true

module Decidim
  module Notify
    # This cell renders the card for an instance of a Notify Chapter
    class ChapterCell < Decidim::ViewModel
      include Decidim::LayoutHelper

      property :title

      def show
        @form = Decidim::Notify::ChapterForm.from_params(title:)
        render
      end

      def id
        return "unclassified" unless model&.id

        model.id
      end

      def note_taker?
        return unless current_user

        Author.for(model.component).note_takers.find_by(user: current_user)
      end

      def notes
        return [] unless model&.notes

        model.notes
      end

      def active
        model&.active
      end

      def update_path
        EngineRouter.main_proxy(model.component).chapter_path(model.id)
      end
    end
  end
end
