# frozen_string_literal: true

require "spec_helper"

module Decidim::Notify
  describe ChapterCell, type: :cell do
    subject { my_cell.call }

    controller Decidim::Notify::ConversationsController

    let(:my_cell) { cell("decidim/notify/chapter", chapter) }
    let!(:chapter) { create(:notify_chapter, active:) }
    let(:active) { false }
    let!(:note_taker) { create(:notify_author, :is_note_taker, :with_user, component: chapter.component) }

    context "when rendering a chapter" do
      it "renders the chapter" do
        expect(subject).to have_css(".chapter-title")
        expect(subject).to have_content(chapter.title)
      end

      it "do not render the edit button" do
        expect(subject).not_to have_css(".flag-modal")
      end

      it "is not active" do
        expect(subject).not_to have_css(".active")
      end
    end

    context "when user is note_taker" do
      before do
        allow(my_cell).to receive(:current_user).and_return(note_taker.user)
      end

      it "renders the edit button" do
        expect(subject).to have_css(".flag-modal")
      end
    end

    context "when is active" do
      let(:active) { true }

      it "is active" do
        expect(subject).to have_css(".active")
      end
    end
  end
end
