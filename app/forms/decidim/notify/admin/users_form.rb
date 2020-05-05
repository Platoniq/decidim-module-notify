# frozen_string_literal: true

module Decidim
  module Notify
  	module Admin
	    class UsersForm < Decidim::Form
	      attribute :users, [String]

	      validates :users, presence: true
	    end
	  end
	end
end
