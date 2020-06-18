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

    trait :with_chapter do
      chapter { create(:notify_chapter, component: component) }
    end
  end

  factory :notify_author, class: "Decidim::Notify::Author" do
    component { create(:notify_component) }
    code { Faker::Number.between(1, 20) }
    # name { Faker::Name.name }

    trait :with_user do
      user { create(:user) }
    end
  end

  factory :notify_chapter, class: "Decidim::Notify::Chapter" do
    component { create(:notify_component) }
    title { Faker::Lorem.sentences(3).join("\n") }

    trait :with_user do
      user { create(:user) }
    end
  end
end
