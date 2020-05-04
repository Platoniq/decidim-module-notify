# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

require "decidim/notify/version"

Gem::Specification.new do |s|
  s.version = Decidim::Notify.version
  s.authors = ["Ivan Vergés"]
  s.email = ["ivan@platoniq.net"]
  s.license = "AGPL-3.0"
  s.homepage = "https://github.com/decidim/decidim-module-notify"
  s.required_ruby_version = ">= 2.5"

  s.name = "decidim-notify"
  s.summary = "A decidim notify module"
  s.description = "A note-taker feature focused on conversations."

  s.files = Dir["{app,config,lib}/**/*", "LICENSE-AGPLv3.txt", "Rakefile", "README.md"]

  s.add_dependency "decidim-core", Decidim::Notify.version
end
