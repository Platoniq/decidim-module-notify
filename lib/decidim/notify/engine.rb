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
          mount Decidim::Notify.server => "/cable"
        end
      end
    end
  end
end
