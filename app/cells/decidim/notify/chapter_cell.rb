# frozen_string_literal: true

module Decidim
  module Notify
    # This cell renders the card for an instance of a Notify Chapter
    class ChapterCell < Decidim::ViewModel
      property :title

      def id
        return "unclassified" unless model&.id

        model.id
      end

      def notes
        return [] unless model&.notes

        model.notes
      end

      def active
        model&.active
      end
    end
  end
end
