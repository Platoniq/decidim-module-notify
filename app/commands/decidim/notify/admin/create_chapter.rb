# frozen_string_literal: true

module Decidim
  module Notify
    module Admin
      class CreateChapter < Rectify::Command
        # Public: Initializes the command.
        #
        # form - A chapter form
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

          unset_actives
          create_chapter!

          broadcast(:ok, @chapter)
        end

        attr_reader :form

        private

        def create_chapter!
          @chapter = Chapter.create!(
            title: form.title,
            active: form.active,
            component: current_component
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
