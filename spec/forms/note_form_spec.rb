# frozen_string_literal: true

require "spec_helper"

module Decidim::Notify
  describe NoteForm do
    subject { described_class.from_params(attributes) }

    let(:attributes) do
      {
        code:,
        chapter:,
        body:
      }
    end
    let(:body) { "Father McKentsy is alone" }
    let(:code) { 11 }
    let(:chapter) { create(:notify_chapter) }

    context "when everything is OK" do
      it { is_expected.to be_valid }
    end

    context "when there's no body" do
      let(:body) { nil }

      it { is_expected.not_to be_valid }
    end
  end
end
