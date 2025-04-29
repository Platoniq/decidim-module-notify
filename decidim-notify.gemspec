# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

require "decidim/notify/version"

Gem::Specification.new do |s|
  s.version = Decidim::Notify::VERSION
  s.authors = ["Ivan Vergés"]
  s.email = ["ivan@platoniq.net"]
  s.license = "AGPL-3.0"
  s.homepage = "https://github.com/decidim/decidim-module-notify"
  s.required_ruby_version = ">= 3.0"

  s.name = "decidim-notify"
  s.summary = "A conversation tracker module for Decidim"
  s.description = "A note-taker feature focused on conversations."

  s.files = Dir["{app,config,lib,vendor,db}/**/*", "LICENSE-AGPLv3.txt", "Rakefile", "package.json", "README.md"]

  # Lock Temporarily as it is failing in 0.29 branch. More info: https://github.com/rails/rails/pull/54264
  # s.add_dependency "concurrent-ruby", "= 1.2.2"

  s.add_dependency "decidim-admin", Decidim::Notify::COMPAT_DECIDIM_VERSION
  s.add_dependency "decidim-core", Decidim::Notify::COMPAT_DECIDIM_VERSION

  s.add_development_dependency "decidim-dev", Decidim::Notify::COMPAT_DECIDIM_VERSION
end
