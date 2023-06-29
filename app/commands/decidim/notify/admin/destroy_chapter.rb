# frozen_string_literal: true

module Decidim
  module Notify
    module Admin
      class DestroyChapter < Decidim::Command
        # Public: Initializes the command.
        #
        # chapter - the chapter to be update
        def initialize(chapter)
          @chapter = chapter
        end

        # Executes the command. Broadcasts these events:
        #
        # - :ok when everything is valid.
        # - :invalid if we couldn't proceed.
        #
        # Returns nothing.
        def call
          chapter.destroy!

          broadcast(:ok)
        end

        attr_reader :chapter
      end
    end
  end
end
