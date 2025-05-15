# frozen_string_literal: true

module Decidim
  module Notify
    class Permissions < Decidim::DefaultPermissions
      def permissions
        return permission_action unless permission_action.subject.in? [:notes, :chapter]

        index_action?
        edit_action?

        permission_action
      end

      def index_action?
        return false unless permission_action.action == :index

        component = context.fetch(:current_component)

        if component.settings.private
          return false unless user

          participants = Author.for(component).pluck :decidim_user_id
          allow! if participants.include? user.id
        elsif component.settings.restricted
          allow! if user
        else
          allow!
        end
      end

      def edit_action?
        return false unless user

        case permission_action.action
        when :create, :update, :destroy
          component = context.fetch(:current_component)

          note_takers = Author.for(component).note_takers.pluck :decidim_user_id
          allow! if note_takers.include? user.id
        end
      end
    end
  end
end
