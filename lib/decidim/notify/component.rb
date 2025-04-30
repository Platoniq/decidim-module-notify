# frozen_string_literal: true

require_dependency "decidim/components/namer"

Decidim.register_component(:notify) do |component|
  component.engine = Decidim::Notify::Engine
  component.admin_engine = Decidim::Notify::AdminEngine
  component.icon = "decidim/notify/icon.svg"
  # component.stylesheet = "decidim/notify/notify"
  # component.admin_stylesheet = "decidim/notify/admin"

  component.on(:before_destroy) do |instance|
    # Code executed before removing the component
    raise StandardError, "Can't remove this component, there's notes in it!" if Decidim::Notify::Note.for(instance).any?
  end

  # These actions permissions can be configured in the admin panel
  # component.actions = %w()

  component.settings(:global) do |settings|
    settings.attribute :announcement, type: :text, translated: true, editor: true
    settings.attribute :private, type: :boolean
    settings.attribute :restricted, type: :boolean
  end

  component.settings(:step) do |settings|
    settings.attribute :announcement, type: :text, translated: true, editor: true
  end

  # component.register_resource(:some_resource) do |resource|
  #   # Register a optional resource that can be references from other resources.
  #   resource.model_class_name = "Decidim::Notify::SomeResource"
  #   resource.template = "decidim/notify/some_resources/linked_some_resources"
  # end

  # component.register_stat :some_stat do |context, start_at, end_at|
  #   # Register some stat number to the application
  # end

  component.register_stat :notify_conversations_count, priority: Decidim::StatsRegistry::HIGH_PRIORITY do |components, start_at, end_at|
    conversations = components.published.where(manifest_name: :notify)
    conversations = conversations.where(created_at: start_at..) if start_at.present?
    conversations = conversations.where(created_at: ..end_at) if end_at.present?
    conversations.count
  end

  component.register_stat :notify_notes_count, primary: true, priority: Decidim::StatsRegistry::MEDIUM_PRIORITY do |components, start_at, end_at|
    notes = Decidim::Notify::Note.where(component: components)
    notes = notes.where(created_at: start_at..) if start_at.present?
    notes = notes.where(created_at: ..end_at) if end_at.present?
    notes.count
  end

  component.register_stat :notify_authors_count, priority: Decidim::StatsRegistry::MEDIUM_PRIORITY do |components, start_at, end_at|
    authors = Decidim::Notify::Author.where(component: components)
    authors = authors.where(created_at: start_at..) if start_at.present?
    authors = authors.where(created_at: ..end_at) if end_at.present?
    authors.count
  end

  component.register_stat :notify_chapters_count, priority: Decidim::StatsRegistry::MEDIUM_PRIORITY do |components, start_at, end_at|
    chapters = Decidim::Notify::Chapter.where(component: components)
    chapters = chapters.where(created_at: start_at..) if start_at.present?
    chapters = chapters.where(created_at: ..end_at) if end_at.present?
    chapters.count
  end

  component.seeds do |participatory_space|
    # Add some seeds for this component
    admin_user = Decidim::User.find_by(
      organization: participatory_space.organization,
      email: "admin@example.org"
    )

    params = {
      name: Decidim::Components::Namer.new(participatory_space.organization.available_locales, :notify).i18n_name,
      manifest_name: :notify,
      published_at: Time.current,
      participatory_space:,
      settings: {
        announcement: { en: Faker::Lorem.paragraphs(number: 2).join("\n") },
        private: Faker::Boolean.boolean(true_ratio: 0.5),
        restricted: Faker::Boolean.boolean(true_ratio: 0.5)
      }
    }

    component = Decidim.traceability.perform_action!(
      "publish",
      Decidim::Component,
      admin_user,
      visibility: "all"
    ) do
      Decidim::Component.create!(params)
    end

    notes = [
      "I love dinosaurs, there where amazing beasts!",
      "Dinosaurs when extinct 65 million years ago",
      "Dinosaurs are not really extinct, they evolve into birds!",
      "Actually, there's more species of birds than mammals, so we could say that they still rule the earth!"
    ]

    # Create a chapter
    chapter = Decidim::Notify::Chapter.create!(
      title: "Extinctions",
      active: true,
      component:
    )
    # add admin user as a note taker
    # add a random user as a note taker
    # add 2 users as participants
    participants = [admin_user] + Decidim::User.where(organization: component.organization).sample(3)
    # add avatars and create participants
    participants.each.with_index(1) do |user, index|
      user.avatar = Rack::Test::UploadedFile.new(File.expand_path(File.join(__dir__, "seeds", "avatar#{index}.png")))
      user.save!
      # create author
      author = Decidim::Notify::Author.find_or_create_by(
        user:,
        component:
      )
      author.code = index
      author.admin = index < 3
      author.save!
      # Create a note for the conversation
      Decidim::Notify::Note.create!(
        component:,
        author: author.user,
        creator: admin_user,
        chapter: index > 1 ? chapter : nil,
        body: notes[index - 1]
      )
    end
  end
end
