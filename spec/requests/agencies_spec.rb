require 'rails_helper'

RSpec.describe "Agencies", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/agencies/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /RAILS_ENV=test" do
    it "returns http success" do
      get "/agencies/RAILS_ENV=test"
      expect(response).to have_http_status(:success)
    end
  end

end
