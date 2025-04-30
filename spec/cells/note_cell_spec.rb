# frozen_string_literal: true

require "spec_helper"

module Decidim::Notify
  describe NoteCell, type: :cell do
    subject { my_cell.call }

    controller Decidim::Notify::ConversationsController

    let(:my_cell) { cell("decidim/notify/note", model) }
    let(:model) { create(:notify_note, :with_author) }
    let!(:note_taker) { create(:notify_author, :is_note_taker, :with_user, component: model.component) }

    context "when rendering a note" do
      it "renders the author" do
        expect(subject).to have_css(".note-name")
        expect(subject).to have_content(model.author.name)
      end

      it "renders the body" do
        expect(subject).to have_css(".note-body")
        expect(subject).to have_content(model.body)
      end

      it "do not render the edit button" do
        expect(subject).to have_no_css(".edit")
      end
    end

    context "when user is note_taker" do
      before do
        allow(my_cell).to receive(:current_user).and_return(note_taker.user)
      end

      it "renders the edit button" do
        expect(subject).to have_css(".edit")
      end
    end
  end
end
