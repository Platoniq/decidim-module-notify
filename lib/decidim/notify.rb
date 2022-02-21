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
        @cable || begin
          @cable = ActionCable::Server::Configuration.new
          @cable.mount_path = config.cable_mount_path
          @cable.connection_class = -> { Decidim::Notify::Connection }
          @cable.url = config.cable_url
          @cable.cable = {
            "adapter" => config.cable_adapter,
            "channel_prefix" => config.cable_channel_prefix
          }
          @cable
        end
      end

      def server
        @server ||= ActionCable::Server::Base.new(config: cable)
      end
    end

    # Notify uses its custom ActionCable server, better not to use the default /cable route as it causes conflicts
    config_accessor :cable_mount_path do
      "/notify_cable"
    end

    # Not recommended to use "async", event for development
    # postgresql has a 8000 character limitation
    config_accessor :cable_adapter do
      "postgresql"
    end

    # Next 2 values are only important if cable_adapter is "redis"
    config_accessor :cable_url do
      "redis://localhost:6379/1"
    end

    config_accessor :cable_channel_prefix do
      "notify_"
    end
  end
end
