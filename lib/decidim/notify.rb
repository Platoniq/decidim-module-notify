# frozen_string_literal: true

require "decidim/notify/admin"
require "decidim/notify/engine"
require "decidim/notify/admin_engine"
require "decidim/notify/component"

module Decidim
  # This namespace holds the logic of the `Notify` component. This component
  # allows users to create notify in a participatory space.
  module Notify
    include ActiveSupport::Configurable

    class << self
      def cable
        return @cable if @cable

        @cable = ActionCable::Server::Configuration.new
        @cable.mount_path = config.cable_mount_path,
                            @cable.connection_class = -> { Decidim::Notify::Connection }
        @cable.cable = {
          "adapter" => config.cable_adapter
        }
        @cable
      end

      def server
        return @server if @server

        @server = ActionCable::Server::Base.new
        @server.config = cable
        @server
      end
    end

    config_accessor :cable_mount_path do
      "/cable"
    end

    config_accessor :cable_adapter do
      "postgresql"
    end

    config_accessor :cable_adapter_url do
      "redis://localhost:6379/1"
    end
  end
end
