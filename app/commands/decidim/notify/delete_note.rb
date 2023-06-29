# frozen_string_literal: true

module Decidim
  module Notify
    class DeleteNote < Decidim::Command
      # Public: Initializes the command.
      #
      def initialize(id)
        @id = id
      end

      # Executes the command. Broadcasts these events:
      #
      # - :ok when everything is valid.
      # - :invalid if we couldn't proceed.
      #
      # Returns nothing.
      def call
        note = Note.for(current_component).find(@id)
        note.destroy!

        broadcast(:ok)
      rescue ActiveRecord::ActiveRecordError => e
        broadcast(:invalid, e.message)
      end
    end
  end
end
