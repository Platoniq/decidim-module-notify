# frozen_string_literal: true

require "spec_helper"

module Decidim::Notify::Admin
  describe ChaptersController, type: :controller do
    routes { Decidim::Notify::AdminEngine.routes }

    let(:organization) { create :organization }
    let(:user) { create(:user, :confirmed, :admin, organization: organization) }
    let(:participatory_space) { create(:participatory_process, organization: organization) }
    let(:component) { create :notify_component, participatory_space: participatory_space }
    let(:chapter) { create :notify_chapter, component: component }
    let(:author) { create :notify_author, :is_note_taker, component: component, user: user }

    let(:form) do
      {
        title: Faker::Lorem.sentence,
        active: false
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
        get :index
        expect(response).to have_http_status(:ok)
        expect(subject).to render_template(:index)
      end
    end

    describe "GET #new" do
      it "renders the empty form" do
        get :new
        expect(response).to have_http_status(:ok)
        expect(subject).to render_template(:new)
      end
    end

    describe "POST #create" do
      let(:params) do
        {
          chapter: form
        }
      end

      context "when there is permission" do
        it "returns ok" do
          post :create, params: params
          expect(flash[:notice]).not_to be_empty
          expect(response).to have_http_status(:found)
        end

        it "creates the new chapter" do
          post :create, params: params
          expect(Decidim::Notify::Chapter.first.title).to eq(form[:title])
        end
      end
    end

    describe "PATCH #update" do
      let!(:chapter) { create :notify_chapter, component: component }
      let(:params) do
        {
          id: chapter.id,
          chapter: form
        }
      end

      context "when there is permission" do
        it "returns ok" do
          patch :update, params: params
          expect(flash[:notice]).not_to be_empty
          expect(response).to have_http_status(:found)
        end

        it "updates the new chapter" do
          patch :update, params: params
          expect(Decidim::Notify::Chapter.first.title).to eq(form[:title])
        end
      end
    end

    describe "DELETE #destroy" do
      let!(:chapter) { create :notify_chapter, component: component }
      let(:params) do
        {
          id: chapter.id
        }
      end

      context "when there is permission" do
        it "returns ok" do
          delete :destroy, params: params
          expect(flash[:notice]).not_to be_empty
          expect(response).to have_http_status(:found)
        end

        it "updates the new chapter" do
          delete :destroy, params: params
          expect { chapter.reload }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end
end
