# frozen_string_literal: true

require "spec_helper"

module Decidim::Notify
  describe ChapterForm do
    subject { described_class.from_params(attributes) }

    let(:attributes) do
      {
        title: title,
        active: false
      }
    end
    let(:title) { "We need to talk..." }

    context "when everything is OK" do
      it { is_expected.to be_valid }
    end

    # context "when there's no title" do
    #   let(:title) { nil }

    #   it { is_expected.not_to be_valid }
    # end
  end
end
