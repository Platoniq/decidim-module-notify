# frozen_string_literal: true

require "active_support/concern"

module Decidim
  module Notify
    module Broadcasts
      extend ActiveSupport::Concern

      included do
        def broadcast_create_note(note)
          html = render_to_string(partial: "note", locals: { note: note })
          Decidim::Notify.server.broadcast("notify-notes-#{current_component.id}", create: html)
        end

        def broadcast_update_note(note)
          html = render_to_string(partial: "note", locals: { note: note })
          Decidim::Notify.server.broadcast("notify-notes-#{current_component.id}", id: note.id, update: html)
        end

        def broadcast_destroy_note(id)
          Decidim::Notify.server.broadcast("notify-notes-#{current_component.id}", destroy: id)
        end

        def broadcast_participants(participants)
          html = render_to_string(partial: "decidim/notify/conversations/participant", collection: participants)
          Decidim::Notify.server.broadcast("notify-participants-#{current_component.id}", html)
        end
      end
    end
  end
end
