# frozen_string_literal: true

module Decidim
  module Notify
    module Admin
      class UpdateConfig < Rectify::Command
        # Public: Initializes the command.
        #
        # form - A config form
        def initialize(form)
          @form = form
        end

        # Executes the command. Broadcasts these events:
        #
        # - :ok when everything is valid.
        # - :invalid if we couldn't proceed.
        #
        # Returns nothing.
        def call
          return broadcast(:invalid) if form.invalid?

          begin
            remove_users
            update_users
            update_config

            broadcast(:ok, @participants)
          rescue ActiveRecord::RecordInvalid => e
            broadcast(:invalid, e.message)
          end
        end

        attr_reader :form

        private

        def update_config
          current_component.attributes["settings"]["global"]["private"] = form.private
          current_component.save!
        end

        def update_users
          @participants = []
          all_users.each_with_index do |id, idx|
            user = Decidim::User.find_by(id: id, organization: current_organization)
            next unless user

            author = Author.find_or_create_by(
              user: user,
              component: current_component
            )
            author.code = idx + 1
            author.admin = form.note_takers.include?(user.id.to_s)
            author.save!
            @participants << author
          end
        end

        def remove_users
          Author.for(current_component).destroy_all
        end

        def all_users
          @all_users ||= (form.users + form.note_takers).uniq.reject(&:blank?)
        end
      end
    end
  end
end
