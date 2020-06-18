# frozen_string_literal: true

require "decidim/core/test/factories"

FactoryBot.define do
  factory :notify_component, parent: :component do
    name { Decidim::Components::Namer.new(participatory_space.organization.available_locales, :notify).i18n_name }
    manifest_name { :notify }
    participatory_space { create(:participatory_process, :with_steps) }
  end

  factory :notify_note, class: "Decidim::Notify::Note" do
    component { create(:notify_component) }
    body { Faker::Lorem.sentences(3).join("\n") }
    creator { create(:user) }

    trait :with_author do
      author { create(:user) }
    end
    # chapter
  end
end
