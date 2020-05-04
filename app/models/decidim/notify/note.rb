# frozen_string_literal: true

module Decidim
  module Notify
    # The data store for a Task in the Decidim::Notify component.
    class Note < ApplicationRecord
      self.table_name = :decidim_notify_notes
    end
  end
end
