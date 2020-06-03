# frozen_string_literal: true

module Decidim
  module Notify
    module Admin
      class ChapterForm < Decidim::Form
        attribute :title, String
        attribute :active, Boolean

        validates :title, presence: true
      end
    end
  end
end
