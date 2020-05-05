# frozen_string_literal: true

module Decidim
  module Notify
    class NoteForm < Decidim::Form
      attribute :code, Integer
      attribute :body, String

      validates :code, :body, presence: true
    end
  end
end
