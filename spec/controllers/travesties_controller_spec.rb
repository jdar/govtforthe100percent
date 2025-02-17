require 'spec_helper'

describe TravestiesController do
  it_behaves_like 'localized request', :index

  it "#index" do
    get :index

    expect(response).to have_http_status(:success)
  end

  describe "voting" do
    let(:travesty) { create(:travesty) }

    it "can downvote" do
      post_params = {
        id: travesty.id,
        travesty: {
          downvote: true
        }
      }

      expect do
        post :update, params: post_params
      end.to change { travesty.reload.downvote }.by 1
    end

    it "can upvote" do
      post_params = {
        id: travesty.id,
        travesty: {
          upvote: true
        }
      }

      expect do
        post :update, params: post_params
      end.to change { travesty.reload.upvote }.by 1
    end
  end
end
