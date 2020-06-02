# frozen_string_literal: true

module Decidim
  module Notify
    module Admin
      class Permissions < Decidim::DefaultPermissions
        def permissions
          return permission_action unless user

          return permission_action if permission_action.scope != :admin

          return permission_action unless [:config, :chapter].include? permission_action.subject

          case permission_action.action
          when :index, :create, :update, :destroy
            permission_action.allow!
          end
          permission_action
        end
      end
    end
  end
end
