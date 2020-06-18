# frozen_string_literal: true

require "spec_helper"

module Decidim::Notify::Admin
  describe NotifyConfigForm do
    subject { described_class.from_params(attributes) }

    let(:attributes) do
      {
        users: users,
        note_takers: note_takers,
        private: false,
        restricted: false
      }
    end
    let(:users) { [create(:user)] }
    let(:note_takers) { [create(:user)] }

    context "when everything is OK" do
      it { is_expected.to be_valid }
    end
  end
end
