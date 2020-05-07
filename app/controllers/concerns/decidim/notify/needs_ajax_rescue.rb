# frozen_string_literal: true

require "active_support/concern"

module Decidim
  module Notify
    module NeedsAjaxRescue
      extend ActiveSupport::Concern

      included do
        rescue_from ::Decidim::ActionForbidden, with: :user_has_no_permission

        # Overrides original user permissions handling to take into account ajax
        def user_has_no_permission
          return super unless request.xhr?

          render plain: t("actions.unauthorized", scope: "decidim.core"), status: :forbidden
        end
      end
    end
  end
end
