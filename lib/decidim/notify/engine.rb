# frozen_string_literal: true

require "rails"
require "decidim/core"

module Decidim
  module Notify
    # This is the engine that runs on the public interface of notify.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::Notify

      routes do
        # Add engine routes here
        resources :conversations
        root to: "conversations#index"
      end

      initializer "decidim_notify.assets" do |app|
        app.config.assets.precompile += %w(decidim_notify_manifest.js decidim_notify_manifest.css)
      end

      initializer "decidim_notify.cable" do |_app|
        Decidim::Core::Engine.routes do
          mount Decidim::Notify.server => Decidim::Notify.config.cable_mount_path
        end
      end

      initializer "decidim_notify.cable.logger" do
        Decidim::Notify.cable.logger ||= ::Rails.logger
      end

      initializer "decidim.notify.add_cells_view_paths" do
        Cell::ViewModel.view_paths << File.expand_path("#{Decidim::Notify::Engine.root}/app/cells")
      end
    end
  end
end
