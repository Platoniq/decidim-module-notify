# frozen_string_literal: true

module Decidim
  module Notify
    module Admin
      class ConversationsController < Admin::ApplicationController
        include NeedsAjaxRescue

        def index
          @users = Author.for(current_component).map { |user| OpenStruct.new(text: format_user_name(user), id: user.decidim_user_id) }
          @note_takers = Author.for(current_component).note_takers.map { |user| OpenStruct.new(text: format_user_name(user), id: user.decidim_user_id) }
          @form = form(ConfigForm).instance
        end

        def create
          @form = form(ConfigForm).from_params(params)
          UpdateConfig.call(@form) do
            on(:ok) do |participants|
              flash[:notice] = I18n.t("decidim.notify.admin.conversations.success")
              broadcast_participants participants
            end
            on(:invalid) do |message|
              flash[:alert] = I18n.t("decidim.notify.admin.conversations.error", message: message)
            end
          end
          redirect_to conversations_path
        end

        def users
          respond_to do |format|
            format.json do
              if (term = params[:term].to_s).present?
                query = current_organization.users.order(name: :asc)
                query = query.where("name ILIKE :term OR nickname ILIKE :term OR email ILIKE :term", term: "%#{term}%")

                render json: query.all.collect { |u| { id: u.id, text: format_user_name(u) } }
              else
                render json: []
              end
            end
          end
        end

        private

        def broadcast_participants(participants)
          html = render_to_string(partial: "decidim/notify/conversations/participant", collection: participants)
          Decidim::Notify.server.broadcast("notify-participants-#{current_component.id}", html)
        end

        def format_user_name(user)
          text = "#{user.name} (@#{user.nickname})"
          text = "#{user.code} - #{text}" if defined? user.code
          text
        end
      end
    end
  end
end
