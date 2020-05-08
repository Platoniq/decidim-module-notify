# frozen_string_literal: true

module Decidim
  module Notify
    class UpdateNote < Rectify::Command
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
          note = Note.find(form.id)
          note.author = Author.find_by(code: form.code, component: current_component)&.user
          note.body = form.body
          note.creator = current_user unless note.creator
          note.save!

          broadcast(:ok, note)
        rescue ActiveRecord::ActiveRecordError => e
          broadcast(:invalid, e.message)
        end
      end

      attr_reader :form
    end
  end
end
