# frozen_string_literal: true

module Decidim
  module Notify
    class ChapterForm < Decidim::Form
      mimic :chapter

      attribute :id, Integer
      attribute :title, String
      attribute :active, Boolean
    end
  end
end
