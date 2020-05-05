# frozen_string_literal: true

module Decidim
  module Notify
    module Admin
      class ConversationsController < Admin::ApplicationController
        def index
        	@form = form(UsersForm).instance
        end
      end
    end
  end
end
