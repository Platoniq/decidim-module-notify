# frozen_string_literal: true

module Decidim
  module Notify
    module Admin
      class NotifyConfigForm < Decidim::Form
        attribute :users, [String]
        attribute :note_takers, [String]
        attribute :private, Boolean
        attribute :restricted, Boolean
      end
    end
  end
end
