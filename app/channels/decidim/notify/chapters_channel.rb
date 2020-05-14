# frozen_string_literal: true

module Decidim
  module Notify
    class ChaptersChannel < ActionCable::Channel::Base
      def subscribed
        stream_from current_channel
      end

      private

      def current_channel
        "notify-chapters-#{params[:id]}"
      end
    end
  end
end
