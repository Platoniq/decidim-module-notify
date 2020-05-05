# frozen_string_literal: true

module Decidim
  module Notify
    module Admin
      class ConfigForm < Decidim::Form
        attribute :users, Array[String]
        attribute :note_takers, Array[String]
      end
    end
  end
end
