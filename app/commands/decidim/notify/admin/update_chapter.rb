# frozen_string_literal: true

module Decidim
  module Notify
    module Admin
      class UpdateChapter < Rectify::Command
        # Public: Initializes the command.
        #
        # form - A chapter form
        # chapter - the chapter to be update
        def initialize(form, chapter)
          @form = form
          @chapter = chapter
        end

        # Executes the command. Broadcasts these events:
        #
        # - :ok when everything is valid.
        # - :invalid if we couldn't proceed.
        #
        # Returns nothing.
        def call
          return broadcast(:invalid) if form.invalid?

          unset_actives
          update_chapter!

          broadcast(:ok)
        end

        attr_reader :form, :chapter

        private

        def update_chapter!
          chapter.update!(
            title: form.title,
            active: form.active
          )
        end

        def unset_actives
          return unless form.active

          # rubocop:disable Rails/SkipsModelValidations
          Chapter.for(current_component).update_all(active: false)
          # rubocop:enable Rails/SkipsModelValidations
        end
      end
    end
  end
end
