# frozen_string_literal: true

module Decidim
  module Notify
    module Admin
      class ChaptersController < Admin::ApplicationController
        include Broadcasts

        helper_method :chapters
        def index
          enforce_permission_to :index, :notify_config
        end

        private

        def chapters
          Chapter.for(current_component)
        end
      end
    end
  end
end