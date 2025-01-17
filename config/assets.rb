# frozen_string_literal: true

base_path = File.expand_path("..", __dir__)

Decidim::Webpacker.register_path("#{base_path}/app/packs")
Decidim::Webpacker.register_entrypoints(
  decidim_notify_component: "#{base_path}/app/packs/entrypoints/decidim_notify_component.js",
  decidim_notify_selects: "#{base_path}/app/packs/entrypoints/decidim_notify_selects.js"
)
Decidim::Webpacker.register_stylesheet_import("stylesheets/decidim/notify/notify")
Decidim::Webpacker.register_stylesheet_import("stylesheets/decidim/notify/admin", group: :admin)
