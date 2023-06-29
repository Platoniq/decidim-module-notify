# frozen_string_literal: true

require "spec_helper"
require "decidim/notify/test/shared_examples/component_examples"

module Decidim::Notify
  describe Note do
    subject { note }

    let(:creator) { create(:user) }
    let(:note) { create(:notify_note, creator: creator) }

    it { is_expected.to be_valid }

    include_examples "model component is notify"

    context "when the note is created" do
      it "is associated with a creator" do
        expect(subject.creator).to eq(creator)
      end

      it "is does not have an author" do
        expect(subject.author).to be_nil
      end

      it "is does not have a chapter" do
        expect(subject.chapter).to be_nil
      end
    end

    context "when the note has an author" do
      let(:note) { create(:notify_note, :with_author) }

      it "is has an author" do
        expect(subject.author).to be_a(Decidim::User)
      end
    end

    context "when the note has a chapter" do
      let(:note) { create(:notify_note, :with_chapter) }

      it "is has an chapter" do
        expect(subject.chapter).to be_a(Decidim::Notify::Chapter)
      end
    end
  end
end
