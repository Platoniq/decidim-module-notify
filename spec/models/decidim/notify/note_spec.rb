# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Notify
    describe Note do
      subject { note }

      let(:creator) { create(:user) }
      let(:note) { create(:notify_note, creator: creator) }

      it { is_expected.to be_valid }

      context "when the note is created" do
        it "is associated with a creator" do
          expect(subject.creator).to eq(creator)
        end

        it "is does not have an author" do
          expect(subject.author).to eq(nil)
        end
      end

      context "when the note has an author" do
        let(:note) { create(:notify_note, :with_author) }

        it "is does not have an author" do
          expect(subject.author).to be_a(Decidim::User)
        end
      end
    end
  end
end
