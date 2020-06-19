# frozen_string_literal: true

require "spec_helper"

module Decidim::Notify
  describe ParticipantCell, type: :cell do
    subject { my_cell.call }

    controller Decidim::Notify::ConversationsController

    let(:my_cell) { cell("decidim/notify/participant", participant) }
    let!(:participant) { create(:notify_author, :with_user) }

    context "when rendering a participant" do
      it "renders the user" do
        expect(subject).to have_css(".notify-participant")
      end

      it "renders the number" do
        expect(subject).to have_css(".code")
        expect(subject).to have_content(participant.code)
      end
    end
  end
end
