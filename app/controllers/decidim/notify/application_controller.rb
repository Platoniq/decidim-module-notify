# frozen_string_literal: true

module Decidim
  module Notify
    # This controller is the abstract class from which all other controllers of
    # this engine inherit.
    #
    # Note that it inherits from `Decidim::Components::BaseController`, which
    # override its layout and provide all kinds of useful methods.
    class ApplicationController < Decidim::Components::BaseController
      def permission_class_chain
        [::Decidim::Notify::Permissions] + super
      end
    end
  end
end
