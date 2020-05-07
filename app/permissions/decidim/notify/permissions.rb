# frozen_string_literal: true

module Decidim
  module Notify
    class Permissions < Decidim::DefaultPermissions
      def permissions
        return permission_action unless user

        notes_action?

        permission_action
      end

      def notes_action?
        return unless permission_action.subject == :notes

        component = context.fetch(:current_component)

        note_takers = Author.for(component).note_takers.pluck :decidim_user_id
        return allow! if note_takers.include? user.id
      end
    end
  end
end
