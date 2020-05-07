# frozen_string_literal: true

module Decidim
  module Notify
    class ParticipantsChannel < ActionCable::Channel::Base
      def subscribed
        stream_from current_channel
      end

      private

      def current_channel
        "notify-participants-#{params[:id]}"
      end
    end
  end
end
