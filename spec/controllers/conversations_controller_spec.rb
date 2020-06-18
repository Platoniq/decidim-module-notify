# frozen_string_literal: true

require "spec_helper"

module Decidim::Notify
  describe ConversationsController, type: :controller do
    routes { Decidim::Notify::Engine.routes }

    let(:organization) { create :organization }
    let(:user) { create(:user, :confirmed, :admin, organization: organization) }
    let(:participatory_space) { create(:participatory_process, organization: organization) }
    let(:component) { create :notify_component, participatory_space: participatory_space }
    let!(:note) { create :notify_note, component: component }
    let!(:author) { create :notify_author, :is_note_taker, component: component, user: user }

    before do
      request.env["decidim.current_organization"] = organization
      request.env["decidim.current_participatory_space"] = participatory_space
      request.env["decidim.current_component"] = component
      sign_in user
    end

    describe "GET #index" do
      it "renders the index listing" do
        get :index
        expect(response).to have_http_status(:ok)
        expect(subject).to render_template(:index)
      end
    end

    describe "POST #create" do
      let(:params) do
        {
          body: "Once upon a time in the west"
        }
      end

      it "creates a new note" do
        post :create, params: params
        expect(response).to have_http_status(:success)
      end
    end

    describe "PATCH #update" do
      let(:params) do
        {
          id: note.id,
          body: "Once upon a time in the west"
        }
      end

      it "updates the note" do
        patch :update, params: params
        expect(response).to have_http_status(:success)
        expect(Note.find_by(id: note.id).body).to eq(params[:body])
      end
    end

    describe "DELETE #destroy" do
      it "deletes the note" do
        delete :destroy, params: { id: note.id }
        expect(Note.find_by(id: note.id)).to be_nil
      end
    end
  end
end
