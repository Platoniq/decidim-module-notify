# frozen_string_literal: true

require_dependency "decidim/components/namer"

Decidim.register_component(:notify) do |component|
  component.engine = Decidim::Notify::Engine
  component.admin_engine = Decidim::Notify::AdminEngine
  component.icon = "decidim/notify/icon.svg"
  component.stylesheet = "decidim/notify/notify"
  component.admin_stylesheet = "decidim/notify/admin"

  component.on(:before_destroy) do |instance|
    # Code executed before removing the component
    raise StandardEerror, "Can't remove this component, there's notes in it!" if Decidim::Notify::Note.for(instance).any?
  end

  # These actions permissions can be configured in the admin panel
  # component.actions = %w()

  component.settings(:global) do |settings|
    settings.attribute :announcement, type: :text, translated: true, editor: true
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

  # component.seeds do |participatory_space|
  #   # Add some seeds for this component
  # end
end
