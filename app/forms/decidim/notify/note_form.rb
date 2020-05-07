# frozen_string_literal: true

module Decidim
  module Notify
    class NoteForm < Decidim::Form
      attribute :id, Integer
      attribute :code, Integer
      attribute :body, String

      validates :body, presence: true
    end
  end
end
