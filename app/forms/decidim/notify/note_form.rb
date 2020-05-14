# frozen_string_literal: true

module Decidim
  module Notify
    class NoteForm < Decidim::Form
      mimic :note

      attribute :id, Integer
      attribute :code, Integer
      attribute :chapter, String
      attribute :body, String

      validates :body, presence: true
    end
  end
end
