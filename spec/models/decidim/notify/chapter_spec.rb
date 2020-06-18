# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Notify
    describe Chapter do
      subject { chapter }

      let(:chapter) { create(:notify_chapter) }

      it { is_expected.to be_valid }

      context "when the chapter is created" do
        it "is associated with a component" do
          expect(subject.component).to be_a(Decidim::Component)
        end
      end
    end
  end
end
