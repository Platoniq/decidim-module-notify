# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Notify
    describe Author do
      subject { author }

      let(:author) { create(:notify_author) }

      it { is_expected.to be_valid }

      context "when the author is created" do
        it "is associated with a component" do
          expect(subject.component).to be_a(Decidim::Component)
        end

        it "is does not have an user" do
          expect(subject.user).to eq(nil)
        end
      end

      context "when the author has an user" do
        let(:author) { create(:notify_author, :with_user) }

        it "is has an user" do
          expect(subject.user).to be_a(Decidim::User)
        end
      end
    end
  end
end
