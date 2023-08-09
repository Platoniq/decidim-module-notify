# frozen_string_literal: true

require "decidim/gem_manager"

namespace :decidim_notify do
  namespace :webpacker do
    desc "Installs Notify webpacker files in Rails instance application"
    task install: :environment do
      raise "Decidim gem is not installed" if decidim_path.nil?

      install_notify_npm
    end

    desc "Adds Decidim Notify dependencies in package.json"
    task upgrade: :environment do
      raise "Decidim gem is not installed" if decidim_path.nil?

      install_notify_npm
    end

    def install_notify_npm
      notify_npm_dependencies.each do |type, packages|
        system! "npm i --save-#{type} #{packages.join(" ")}"
      end
    end

    def notify_npm_dependencies
      @notify_npm_dependencies ||= begin
        package_json = JSON.parse(File.read(notify_path.join("package.json")))

        {
          prod: package_json["dependencies"].map { |package, version| "#{package}@#{version}" },
          dev: package_json["devDependencies"].map { |package, version| "#{package}@#{version}" }
        }.freeze
      end
    end

    def notify_path
      @notify_path ||= Pathname.new(notify_gemspec.full_gem_path) if Gem.loaded_specs.has_key?(gem_name)
    end

    def notify_gemspec
      @notify_gemspec ||= Gem.loaded_specs[gem_name]
    end

    def rails_app_path
      @rails_app_path ||= Rails.root
    end

    def copy_awesome_file_to_application(origin_path, destination_path = origin_path)
      FileUtils.cp(notify_path.join(origin_path), rails_app_path.join(destination_path))
    end

    def system!(command)
      system("cd #{rails_app_path} && #{command}") || abort("\n== Command #{command} failed ==")
    end

    def gem_name
      "decidim-notify"
    end
  end
end
