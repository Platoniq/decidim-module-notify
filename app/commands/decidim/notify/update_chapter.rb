# frozen_string_literal: true

module Decidim
  module Notify
    class UpdateChapter < Admin::UpdateChapter
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
          @chapter = Chapter.find(form.id)

          unset_actives
          update_chapter!

          broadcast(:ok, @chapter)
        rescue ActiveRecord::ActiveRecordError => e
          broadcast(:invalid, e.message)
        end
      end
    end
  end
end
