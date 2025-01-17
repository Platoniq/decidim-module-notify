# frozen_string_literal: true

require "spec_helper"

module Decidim::Notify::Admin
  describe ConversationsController do
    routes { Decidim::Notify::AdminEngine.routes }

    let(:organization) { create(:organization) }
    let(:user) { create(:user, :confirmed, :admin, organization:) }
    let(:participatory_space) { create(:participatory_process, organization:) }
    let(:component) { create(:notify_component, participatory_space:) }
    let!(:users) { create_list(:user, 3, organization:) }
    let!(:note_takers) { create_list(:user, 2, organization:) }
    let(:params) do
      {
        users: users.pluck(:id).map(&:to_s),
        note_takers: note_takers.pluck(:id).map(&:to_s),
        private: false,
        restricted: false
      }
    end

    before do
      request.env["decidim.current_organization"] = organization
      request.env["decidim.current_participatory_space"] = participatory_space
      request.env["decidim.current_component"] = component
      sign_in user
    end

    describe "GET #index" do
      it "renders the index listing" do
        get(:index, params:)
        expect(response).to have_http_status(:ok)
        expect(subject).to render_template(:index)
      end
    end

    describe "POST #create" do
      context "when there is permission" do
        it "returns ok" do
          post(:create, params:)
          expect(flash[:notice]).not_to be_empty
          expect(response).to have_http_status(:found)
        end

        it "creates users and note_takers for the component" do
          post(:create, params:)
          expect(Decidim::Notify::Author.participants.map(&:user)).to match_array(users)
          expect(Decidim::Notify::Author.note_takers.map(&:user)).to match_array(note_takers)
        end
      end
    end
  end
end
