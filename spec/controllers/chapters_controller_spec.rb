# frozen_string_literal: true

require "spec_helper"

module Decidim::Notify
  describe ChaptersController, type: :controller do
    routes { Decidim::Notify::Engine.routes }

    let(:organization) { create :organization }
    let(:user) { create(:user, :confirmed, :admin, organization: organization) }
    let(:participatory_space) { create(:participatory_process, organization: organization) }
    let(:component) { create :notify_component, participatory_space: participatory_space }
    let!(:chapter) { create :notify_chapter, component: component }
    let!(:author) { create :notify_author, :is_note_taker, component: component, user: user }

    before do
      request.env["decidim.current_organization"] = organization
      request.env["decidim.current_participatory_space"] = participatory_space
      request.env["decidim.current_component"] = component
      sign_in user
    end

    describe "PATCH #update" do
      let(:params) do
        {
          id: chapter.id,
          title: "We need to talk...",
          active: false
        }
      end

      it "creates a new chapter" do
        get :update, params: params
        expect(response).to have_http_status(:success)
      end
    end

    describe "DELETE #destroy" do
      it "deletes the chapter" do
        delete :destroy, params: { id: chapter.id }
        expect(Chapter.find_by(id: chapter.id)).to be_nil
      end
    end
  end
end
