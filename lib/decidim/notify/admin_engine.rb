# frozen_string_literal: true

module Decidim
  module Notify
    # This is the engine that runs on the public interface of `Notify`.
    class AdminEngine < ::Rails::Engine
      isolate_namespace Decidim::Notify::Admin

      paths["db/migrate"] = nil
      paths["lib/tasks"] = nil

      routes do
        # Add admin engine routes here
        resources :conversations do
          #   collection do
          #     resources :exports, only: [:create]
          #   end
        end
        root to: "conversations#index"
      end

      def load_seed
        nil
      end
    end
  end
end
