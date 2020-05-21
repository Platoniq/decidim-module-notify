# frozen_string_literal: true

module Decidim
  module Notify
    module Admin
      class NotifyConfigForm < Decidim::Form
        attribute :users, Array[String]
        attribute :note_takers, Array[String]
        attribute :private, Boolean
      end
    end
  end
end
