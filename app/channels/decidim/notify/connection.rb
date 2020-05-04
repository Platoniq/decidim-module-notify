# frozen_string_literal: true

module Decidim
  module Notify
    class Connection < ActionCable::Connection::Base
      identified_by :session_id

      def connect
        self.session_id = request.session_id
      end
    end
  end
end
