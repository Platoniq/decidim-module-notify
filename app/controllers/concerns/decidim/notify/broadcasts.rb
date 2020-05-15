# frozen_string_literal: true

require "active_support/concern"

module Decidim
  module Notify
    module Broadcasts
      extend ActiveSupport::Concern

      included do
        def broadcast_create_note(note)
          html = render_to_string(partial: "decidim/notify/conversations/note", locals: { note: note })
          Decidim::Notify.server.broadcast("notify-notes-#{current_component.id}", create: html, chapterId: note.chapter&.id)
        end

        def broadcast_update_note(note)
          html = render_to_string(partial: "decidim/notify/conversations/note", locals: { note: note })
          Decidim::Notify.server.broadcast("notify-notes-#{current_component.id}", id: note.id, update: html, chapterId: note.chapter&.id)
        end

        def broadcast_destroy_note(id)
          Decidim::Notify.server.broadcast("notify-notes-#{current_component.id}", destroy: id)
        end

        def broadcast_participants(participants)
          html = render_to_string(partial: "decidim/notify/conversations/participant", collection: participants)
          Decidim::Notify.server.broadcast("notify-participants-#{current_component.id}", html)
        end

        def broadcast_create_chapter(chapter)
          data = {
            id: chapter.id,
            title: chapter.title,
            create: render_to_string(partial: "decidim/notify/conversations/chapter", locals: { chapter: OpenStruct.new(title: chapter.title, id: chapter.id, component: chapter.component) })
          }
          Decidim::Notify.server.broadcast("notify-chapters-#{current_component.id}", data)
        end

        def broadcast_update_chapter(chapter)
          data = {
            id: chapter.id,
            active: chapter.active,
            update: chapter.title
          }
          Decidim::Notify.server.broadcast("notify-chapters-#{current_component.id}", data)
        end

        def broadcast_destroy_chapter(id)
          Decidim::Notify.server.broadcast("notify-chapters-#{current_component.id}", destroy: id)
        end
      end
    end
  end
end
