# frozen_string_literal: true

module Decidim
  module Notify
    class UpdateChapter < Rectify::Command
      # Public: Initializes the command.
      #
      # form - A config form
      def initialize(form)
        @form = form
      end

      # Executes the command. Broadcasts these events:
      #
      # - :ok when everything is valid.
      # - :invalid if we couldn't proceed.
      #
      # Returns nothing.
      def call
        return broadcast(:invalid) if form.invalid?

        begin
          chapter = Chapter.find(form.id)
          # rubocop:disable Rails/SkipsModelValidations
          Chapter.for(chapter.component).update_all(active: false) if form.active
          # rubocop:enable Rails/SkipsModelValidations
          chapter.title = form.title
          chapter.active = form.active
          chapter.save!

          broadcast(:ok, chapter)
        rescue ActiveRecord::ActiveRecordError => e
          broadcast(:invalid, e.message)
        end
      end

      private

      attr_reader :form
    end
  end
end
