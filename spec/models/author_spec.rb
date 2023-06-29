# frozen_string_literal: true

require "spec_helper"
require "decidim/notify/test/shared_examples/component_examples"

module Decidim::Notify
  describe Author do
    subject { author }

    let(:author) { create(:notify_author, :with_user) }

    it { is_expected.to be_valid }

    include_examples "model component is notify"

    context "when the author is created" do
      it "is has an user" do
        expect(subject.user).to be_a(Decidim::User)
      end
    end

    context "when the author has not an user" do
      let(:author) { create(:notify_author) }

      it "is does not have an user" do
        expect(subject.user).to be_nil
      end
    end

    context "when the author has notes" do
      let!(:notes) { create_list(:notify_note, 3, component: author.component, author: author.user) }

      it "returns all his notes" do
        expect(subject.notes).to match_array(notes)
      end
    end
  end
end
