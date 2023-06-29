# frozen_string_literal: true

require "decidim/dev/common_rake"

def install_module(path)
  Dir.chdir(path) do
    system("bundle exec rake decidim_notify:install:migrations")
    system("bundle exec rake db:migrate")
  end
end

def override_webpacker_config_files(path)
  Dir.chdir(path) do
    system("bundle exec rake decidim_notify:webpacker:install")
  end
end

def seed_db(path)
  Dir.chdir(path) do
    system("bundle exec rake db:seed")
  end
end

desc "Generates a dummy app for testing"
task test_app: "decidim:generate_external_test_app" do
  ENV["RAILS_ENV"] = "test"
  install_module("spec/decidim_dummy_app")
  fix_babel_config("spec/decidim_dummy_app")
  override_webpacker_config_files("spec/decidim_dummy_app")
end

desc "Generates a development app."
task :development_app do
  Bundler.with_original_env do
    generate_decidim_app(
      "development_app",
      "--app_name",
      "#{base_app_name}_development_app",
      "--path",
      "..",
      "--recreate_db",
      "--demo"
    )
  end

  install_module("development_app")
  fix_babel_config("development_app")
  override_webpacker_config_files("development_app")
  seed_db("development_app")
end

def fix_babel_config(path)
  Dir.chdir(path) do
    babel_config = "#{Dir.pwd}/babel.config.json"
    File.delete(babel_config) if File.exist?(babel_config)
    FileUtils.cp("#{__dir__}/babel.config.json", Dir.pwd)

    # Temporary fix to overcome the issue with sass-embedded, see:
    # https://github.com/decidim/decidim/pull/11074
    system("npm i sass-embedded@~1.62.0")
  end
end
