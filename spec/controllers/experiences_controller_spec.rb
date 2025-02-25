require 'spec_helper'

describe ExperiencesController do
  it_behaves_like 'localized request', :index

  it "#index" do
    get :index

    expect(response).to have_http_status(:success)
  end

  describe "voting" do
    let(:experience) { create(:experience) }

    it "can downvote" do
      post_params = {
        id: experience.id,
        experience: {
          downvote: true
        }
      }

      expect do
        post :update, params: post_params
      end.to change { experience.reload.downvote }.by 1
    end

    it "can upvote" do
      post_params = {
        id: experience.id,
        experience: {
          upvote: true
        }
      }

      expect do
        post :update, params: post_params
      end.to change { experience.reload.upvote }.by 1
    end
  end
end
