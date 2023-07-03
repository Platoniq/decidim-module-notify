# frozen_string_literal: true

module Decidim
  module Notify
    class TypingChannel < ActionCable::Channel::Base
      def subscribed
        stream_from current_channel
      end

      def start_typing
        ActionCable.server.broadcast(current_channel, { typing: true, user_id: session_id })
      end

      def stop_typing
        ActionCable.server.broadcast(current_channel, { typing: false, user_id: session_id })
      end

      private

      def current_channel
        "notify-typing-#{params[:id]}"
      end
    end
  end
end
