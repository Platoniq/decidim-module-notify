# frozen_string_literal: true

require "spec_helper"
require "decidim/notify/test/shared_examples/component_examples"

module Decidim::Notify
  describe Chapter do
    subject { chapter }

    let(:chapter) { create(:notify_chapter) }

    it { is_expected.to be_valid }

    include_examples "model component is notify"
  end
end
